import 'package:web3flutter/errors/exceptions.dart';
import 'package:web3flutter/errors/failure.dart';
import 'package:web3dart/web3dart.dart';
import 'package:dartz/dartz.dart';
import 'package:web3flutter/web3/data/data_sources/web3_data_source.dart';
import '../../data/repositories/web3_repository.dart';
import '../params/write_on_contract_params.dart';
import '../params/read_contract_params.dart';
import '../params/get_balance_params.dart';
import '../params/deploy_contract_params.dart';
import '../params/cancel_transaction_params.dart';
import '../entities/transaction_info_entity.dart';

class Web3RepositoryImpl implements Web3Repository {
  final Web3DataSource dataSource;
  Web3RepositoryImpl({required this.dataSource});
  @override
  Future<Either<Failure, String>> cancelTransaction({
    required CancelTransactionParams params,
  }) async {
    try {
      return Right(await dataSource.cancelTransaction(params: params));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, DeployedContract>> deployContract({
    required DeployContractParams params,
  }) async {
    try {
      return Right(await dataSource.deployContract(params: params));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getBalance({
    required GetBalanceParams params,
  }) async {
    try {
      return Right(await dataSource.getBalance(params: params));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getTransactionCount({BlockNum? atBlock}) async {
    try {
      return Right(await dataSource.getTransactionCount(atBlock: atBlock));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, TransactionInformation>> getTransactionInformation({
    required String transactionHash,
  }) async {
    try {
      return Right(
        await dataSource.getTransactionInformation(
          transactionHash: transactionHash,
        ),
      );
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> readContract({
    required ReadContractParams params,
  }) async {
    try {
      return Right(await dataSource.readContract(params: params));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, TransactionInfo?>> writeOnContract({
    required WriteOnContractParams params,
  }) async {
    try {
      return Right(await dataSource.writeOnContract(params: params));
    } on Web3Exception catch (e) {
      return Left(e.toFailure());
    }
  }
}
