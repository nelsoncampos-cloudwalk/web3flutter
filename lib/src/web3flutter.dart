import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart' as crypto;

typedef TransactionEvent = void Function(List<dynamic>);

class Web3Flutter {
  final String? privateKey;
  final String publicKey;
  final String url;
  late final Web3Client web3;

  Web3Flutter({
    required this.url,
    required this.publicKey,
    this.privateKey,
  }) {
    web3 = Web3Client(url, Client());
  }

  ///Get [publickey] and convert to a readable address to web3dart
  EthereumAddress get address {
    if (publicKey.startsWith('0x')) {
      return EthereumAddress.fromHex(publicKey);
    }
    final publicKeyBytes = crypto.hexToBytes(
      publicKey.substring(2, publicKey.length),
    );
    final addressBytes = crypto.publicKeyToAddress(publicKeyBytes);
    final publicKeyAddress = crypto.bytesToHex(addressBytes, include0x: true);
    return EthereumAddress.fromHex(publicKeyAddress);
  }

  int _gasPrice(
    int gasPrice,
    int maxGasPrice,
    int minGasPrice,
  ) {
    if (gasPrice != -1) {
      if (gasPrice > maxGasPrice) {
        return maxGasPrice;
      } else if (gasPrice < minGasPrice) {
        return minGasPrice;
      } else {
        return gasPrice;
      }
    } else {
      return gasPrice;
    }
  }

  ///Get the balance of the main token in the network
  Future<double> getBalance({
    ///Select the type of unit you want to receive
    EtherUnit unit = EtherUnit.ether,

    ///If you want you can get the balance of a especific block
    BlockNum? atBlock,
  }) async {
    final EtherAmount balance = await web3.getBalance(
      address,
      atBlock: atBlock,
    );
    return balance.getValueInUnit(unit);
  }

  ///Gets the amount of transactions issued by the specified [address].
  ///This function allows specifying a custom block mined in the past to get historical data. By default, [BlockNum.current] will be used.
  Future<int> getTransactionCount({BlockNum? atBlock}) async {
    final int count = await web3.getTransactionCount(address);
    return count;
  }

  ///Create a [DeployedContract] to help call the contracts
  Future<DeployedContract> deployContract({
    required String abiPath,
    required String contractName,
    required String contractAddress,
  }) async {
    final String abi = await rootBundle.loadString(abiPath);
    final contract = DeployedContract(
      ContractAbi.fromJson(abi, contractName),
      EthereumAddress.fromHex(contractAddress),
    );
    return contract;
  }

  Future<String> cancelTransaction({
    required int gasPrice,
    required int nonce,
    required String transactionHash,
    int? maxGas,
    int chainId = 4,
  }) async {
    if (privateKey == null) {
      throw Exception(
        "cancelTransaction only can used if have the private key",
      );
    }

    final Credentials credentials = EthPrivateKey.fromHex(privateKey!);

    final to = EthereumAddress.fromHex(
      "0x0000000000000000000000000000000000000000",
    );

    final etherAmount = EtherAmount.fromUnitAndValue(EtherUnit.gwei, gasPrice);

    final int? transactionMaxGas = maxGas ?? 240000;

    final hash = await web3.sendTransaction(
      credentials,
      Transaction(
        to: to,
        gasPrice: etherAmount,
        maxGas: transactionMaxGas,
        nonce: nonce,
      ),
      chainId: chainId,
    );

    return hash;
  }

  void listenContractEvent(
    DeployedContract contract,
    String event,
    String publicKey, {
    required TransactionEvent onTransaction,
  }) {
    ContractEvent transactionEvent = contract.event(event);
    final events = web3.events(
      FilterOptions.events(
        contract: contract,
        event: transactionEvent,
      ),
    );
    events.listen((event) {
      final decodedResults = transactionEvent.decodeResults(
        event.topics ?? <String>[],
        event.data ?? '',
      );
      final from = decodedResults[0] as EthereumAddress;
      if (from.hex == publicKey) {
        onTransaction(decodedResults);
      }
    });
  }

  Future<String> writeOnContract(
    ///Function name from contract that you will write
    String functionName,
    List<dynamic> args, {
    required DeployedContract contract,
    required int gasPrice,

    ///Event name that you want listen
    required String eventName,

    ///the id from blockchain where your smart contract is deployed
    required int chainId,
    int? maxGas,
    required int minGasPrice,
    required int maxGasPrice,

    ///Callback when trasaction have completed
    required TransactionEvent onTransaction,

    ///Callback when trasaction had some error
    required Function onError,
  }) async {
    assert(privateKey == null);

    final contractFunction = contract.function(functionName);
    final credentials = EthPrivateKey.fromHex(privateKey!);
    final nonce = await getTransactionCount();

    listenContractEvent(
      contract,
      eventName,
      (await credentials.extractAddress()).hex,
      onTransaction: (result) {
        onTransaction(result);
      },
    );

    final transactionHash = await web3.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contractFunction,
        parameters: args,
        gasPrice: gasPrice != -1
            ? EtherAmount.fromUnitAndValue(
                EtherUnit.gwei,
                _gasPrice(gasPrice, maxGasPrice, minGasPrice),
              )
            : null,
        maxGas: maxGas ?? 24000,
        nonce: nonce,
      ),
      chainId: chainId,
    );
    return transactionHash;
  }

  Future<TransactionInformation> getTransactionInformation({
    required String transactionHash,
  }) async {
    return await web3.getTransactionByHash(transactionHash);
  }

  // @override
  // dynamic parseEvent(
  //   DeployedContract contract,
  //   String eventName,
  //   PGSTransactionItemGetResponse event,
  // ) {
  //   ContractEvent _transactionEvent() => contract.event(eventName);
  //   return _transactionEvent().decodeResults(event.topics, event.data);
  // }

  Future<dynamic> readContract(
    String functionName,
    List<dynamic> args, {
    required DeployedContract contract,
  }) async {
    final function = contract.function(functionName);

    return await web3.call(
      sender: address,
      contract: contract,
      function: function,
      params: args,
    );
  }

  // @override
  // Future<BlockchainWallet> createWallet() async {
  //   final rng = Random.secure();
  //   final Credentials creds = EthPrivateKey.createRandom(rng);
  //   final pass = Uuid().v4();
  //   final Wallet wallet = Wallet.createNew(creds, pass, rng);
  //   final address = await creds.extractAddress();
  //   final add = EthereumAddress.fromHex(address.toString());
  //   final String ppk = HEX.encode(wallet.privateKey.privateKey);
  //   final json = BlockchainWallet(privateKey: ppk, publicKey: add.hex).toJson();
  //   return BlockchainWallet.fromJson(json);
  // }

}
