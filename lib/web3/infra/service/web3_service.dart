import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart' as crypto;
import 'package:web3flutter/web3/data/model/transaction_info_response.dart';

typedef TransactionEvent = void Function(List<dynamic>);

class Web3Service {
  final Client client;
  final String? privateKey;
  final String publicKey;
  late Web3Client web3;

  Web3Service({
    required this.client,
    required String url,
    required this.publicKey,
    this.privateKey,
  }) {
    web3 = Web3Client(url, client);
  }

  EthereumAddress get address {
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

  Future<double> getBalance({
    EtherUnit unit = EtherUnit.ether,
    BlockNum? atBlock,
  }) async {
    final EtherAmount balance = await web3.getBalance(
      address,
      atBlock: atBlock,
    );
    return balance.getValueInUnit(unit);
  }

  Future<int> getTransactionCount({BlockNum? atBlock}) async {
    final int count = await web3.getTransactionCount(address);
    return count;
  }

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

  Future<TransactionInfoResponse?> writeOnContract(
    String functionName,
    List<dynamic> args, {
    required DeployedContract contract,
    required int gasPrice,
    required String eventName,
    required int chainId,
    int? maxGas,
    required int minGasPrice,
    required int maxGasPrice,
    required TransactionEvent onTransaction,
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
    return TransactionInfoResponse(
      nonce: nonce,
      gasPrice: gasPrice,
      transactionHash: transactionHash,
      maxGas: maxGas,
    );
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
