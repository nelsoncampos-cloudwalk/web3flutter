import 'package:web3dart/web3dart.dart';
import 'package:web3flutter/web3/domain/entities/transaction_info_entity.dart';
import "../../domain/params/cancel_transaction_params.dart";
import '../../domain/params/deploy_contract_params.dart';
import '../../domain/params/get_balance_params.dart';
import '../../domain/params/read_contract_params.dart';
import '../../domain/params/write_on_contract_params.dart';

abstract class Web3DataSource {
  Future<double> getBalance({required GetBalanceParams params});
  Future<int> getTransactionCount({BlockNum? atBlock});

  Future<DeployedContract> deployContract({
    required DeployContractParams params,
  });

  Future<String> cancelTransaction({
    required CancelTransactionParams params,
  });

  Future<TransactionInfo?> writeOnContract({
    required WriteOnContractParams params,
  });

  Future<TransactionInformation> getTransactionInformation({
    required String transactionHash,
  });

  Future<dynamic> readContract({required ReadContractParams params});
}
