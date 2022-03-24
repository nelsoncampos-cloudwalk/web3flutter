import 'package:dartz/dartz.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3flutter/errors/failure.dart';
import 'package:web3flutter/web3/domain/entities/transaction_info_entity.dart';
import "../../domain/params/cancel_transaction_params.dart";
import '../../domain/params/deploy_contract_params.dart';
import '../../domain/params/get_balance_params.dart';
import '../../domain/params/read_contract_params.dart';
import '../../domain/params/write_on_contract_params.dart';

abstract class Web3Repository {
  Future<Either<Failure, double>> getBalance({
    required GetBalanceParams params,
  });

  Future<Either<Failure, int>> getTransactionCount({BlockNum? atBlock});

  Future<Either<Failure, DeployedContract>> deployContract({
    required DeployContractParams params,
  });

  Future<Either<Failure, String>> cancelTransaction({
    required CancelTransactionParams params,
  });

  Future<Either<Failure, TransactionInfo?>> writeOnContract({
    required WriteOnContractParams params,
  });

  Future<Either<Failure, TransactionInformation>> getTransactionInformation({
    required String transactionHash,
  });

  Future<Either<Failure, dynamic>> readContract({
    required ReadContractParams params,
  });
}
