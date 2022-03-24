import 'package:dartz/dartz.dart';
import '../params/deploy_contract_params.dart';
import '../params/read_contract_params.dart';
import '../usecases/deploy_contract.dart';
import '../usecases/read_contract.dart';
import '../../../errors/failure.dart';

abstract class ReadContractRoutine {
  Future<Either<Failure, dynamic>> call({
    required ReadContractParams readContractParams,
    required DeployContractParams deployContractParams,
  });
}

class ReadContractRoutineImpl implements ReadContractRoutine {
  final DeployContract deployContract;
  final ReadContract readContract;

  ReadContractRoutineImpl({
    required this.deployContract,
    required this.readContract,
  });

  @override
  Future<Either<Failure, dynamic>> call({
    required ReadContractParams readContractParams,
    required DeployContractParams deployContractParams,
  }) async {
    final deployedContractResult = await deployContract(
      params: deployContractParams,
    );
    return deployedContractResult.fold(
      (failure) {
        return Left(failure);
      },
      (deployedContract) async {
        return await readContract(
          params: readContractParams.copyWith(
            contract: deployedContract,
          ),
        );
      },
    );
  }
}
