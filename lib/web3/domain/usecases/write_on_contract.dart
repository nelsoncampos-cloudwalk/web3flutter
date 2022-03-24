import 'package:dartz/dartz.dart';
import '../entities/transaction_info_entity.dart';
import '../params/write_on_contract_params.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class WriteOnContract {
  Future<Either<Failure, TransactionInfo?>> call({
    required WriteOnContractParams params,
  });
}

class WriteOnContractImpl implements WriteOnContract {
  final Web3Repository repository;

  WriteOnContractImpl({required this.repository});

  @override
  Future<Either<Failure, TransactionInfo?>> call({
    required WriteOnContractParams params,
  }) async {
    return repository.writeOnContract(
      params: params,
    );
  }
}
