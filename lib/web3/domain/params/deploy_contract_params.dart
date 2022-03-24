import 'package:equatable/equatable.dart';

class DeployContractParams extends Equatable {
  final String abiPath;
  final String contractAddress;
  final String contractName;
  const DeployContractParams({
    required this.abiPath,
    required this.contractAddress,
    required this.contractName,
  });

  @override
  List<Object> get props => [
        abiPath,
        contractAddress,
        contractAddress,
      ];
}
