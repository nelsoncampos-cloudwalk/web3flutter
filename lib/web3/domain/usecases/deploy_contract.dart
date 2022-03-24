import 'package:dartz/dartz.dart';
import 'package:web3dart/contracts.dart';
import '../params/deploy_contract_params.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class DeployContract {
  Future<Either<Failure, DeployedContract>> call({
    required DeployContractParams params,
  });
}

class DeployContractImpl implements DeployContract {
  final Web3Repository repository;

  DeployContractImpl({required this.repository});

  @override
  Future<Either<Failure, DeployedContract>> call({
    required DeployContractParams params,
  }) async {
    return repository.deployContract(params: params);
  }
}
