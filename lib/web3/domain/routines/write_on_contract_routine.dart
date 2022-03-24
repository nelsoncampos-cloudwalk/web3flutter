import 'package:dartz/dartz.dart';
import 'package:web3flutter/web3/domain/usecases/write_on_contract.dart';
import '../params/write_on_contract_params.dart';
import '../params/deploy_contract_params.dart';
import '../usecases/deploy_contract.dart';
import '../../../errors/failure.dart';

abstract class WriteOnContractRoutine {
  Future<Either<Failure, dynamic>> call({
    required WriteOnContractParams writeOnContractParams,
    required DeployContractParams deployContractParams,
  });
}

class WriteOnContractRoutineImpl implements WriteOnContractRoutine {
  final DeployContract deployContract;
  final WriteOnContract writeOnContract;

  WriteOnContractRoutineImpl({
    required this.deployContract,
    required this.writeOnContract,
  });

  @override
  Future<Either<Failure, dynamic>> call({
    required WriteOnContractParams writeOnContractParams,
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
        return await writeOnContract(
          params: writeOnContractParams.copyWith(
            contract: deployedContract,
          ),
        );
      },
    );
  }
}
