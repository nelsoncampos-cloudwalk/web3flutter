import 'package:dartz/dartz.dart';
import '../params/read_contract_params.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class ReadContract {
  Future<Either<Failure, dynamic>> call({
    required ReadContractParams params,
  });
}

class ReadContractImpl implements ReadContract {
  final Web3Repository repository;

  ReadContractImpl({required this.repository});

  @override
  Future<Either<Failure, dynamic>> call({
    required ReadContractParams params,
  }) async {
    return repository.readContract(
      params: params,
    );
  }
}
