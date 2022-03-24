import 'package:web3dart/web3dart.dart';
import 'package:web3flutter/errors/exceptions.dart';
import '../../data/data_sources/web3_data_source.dart';
import '../../domain/entities/transaction_info_entity.dart';
import '../../domain/params/write_on_contract_params.dart';
import '../../domain/params/read_contract_params.dart';
import '../../domain/params/get_balance_params.dart';
import '../../domain/params/deploy_contract_params.dart';
import '../../domain/params/cancel_transaction_params.dart';
import '../service/web3_service.dart';

class Web3DataSourceImpl implements Web3DataSource {
  final Web3Service service;
  const Web3DataSourceImpl({required this.service});

  @override
  Future<String> cancelTransaction({
    required CancelTransactionParams params,
  }) async {
    try {
      return await service.cancelTransaction(
        gasPrice: params.gasPrice,
        nonce: params.nonce,
        transactionHash: params.transactionHash,
        maxGas: params.maxGas,
        chainId: params.chainId,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: cancelTransaction()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<DeployedContract> deployContract({
    required DeployContractParams params,
  }) async {
    try {
      return await service.deployContract(
        abiPath: params.abiPath,
        contractAddress: params.contractAddress,
        contractName: params.contractName,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: deployContract()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<double> getBalance({required GetBalanceParams params}) async {
    try {
      return await service.getBalance(
        unit: params.unit,
        atBlock: params.atBlock,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: getBalance()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<int> getTransactionCount({BlockNum? atBlock}) async {
    try {
      return await service.getTransactionCount(
        atBlock: atBlock,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: getTransactionCount()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<TransactionInformation> getTransactionInformation({
    required String transactionHash,
  }) async {
    try {
      return await service.getTransactionInformation(
        transactionHash: transactionHash,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: getTransactionInformation()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<dynamic> readContract({required ReadContractParams params}) async {
    try {
      return await service.readContract(
        params.functionName,
        params.args,
        contract: params.contract,
      );
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: readContract()",
        extraData: {'Exception': e},
      );
    }
  }

  @override
  Future<TransactionInfo?> writeOnContract({
    required WriteOnContractParams params,
  }) async {
    try {
      final transactionInfo = await service.writeOnContract(
        params.functionName,
        params.args,
        contract: params.contract,
        gasPrice: params.gasPrice,
        eventName: params.eventName,
        chainId: params.chainId,
        minGasPrice: params.minGasPrice,
        maxGasPrice: params.maxGasPrice,
        onTransaction: params.onTransaction,
        onError: params.onError,
      );

      return transactionInfo?.parseToEntity();
    } catch (e) {
      throw Web3Exception(
        title: "Web3DataSourceImpl",
        message: "Error on: writeOnContract()",
        extraData: {'Exception': e},
      );
    }
  }
}
