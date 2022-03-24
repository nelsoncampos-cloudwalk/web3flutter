import 'package:equatable/equatable.dart';
import 'package:web3dart/contracts.dart';

class ReadContractParams extends Equatable {
  final String functionName;
  final List<dynamic> args;
  final DeployedContract contract;

  const ReadContractParams({
    required this.functionName,
    required this.args,
    required this.contract,
  });

  ReadContractParams copyWith({
    String? functionName,
    List<dynamic>? args,
    DeployedContract? contract,
  }) {
    return ReadContractParams(
      functionName: functionName ?? this.functionName,
      args: args ?? this.args,
      contract: contract ?? this.contract,
    );
  }

  @override
  List<Object> get props => [
        functionName,
        args,
        contract,
      ];
}
