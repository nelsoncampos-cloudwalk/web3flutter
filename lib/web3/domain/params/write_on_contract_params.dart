import 'package:equatable/equatable.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3flutter/web3/infra/service/web3_service.dart';

class WriteOnContractParams extends Equatable {
  final String functionName;
  final List<dynamic> args;
  final DeployedContract contract;
  final int gasPrice;
  final String eventName;
  final int chainId;
  int? maxGas;
  final int minGasPrice;
  final int maxGasPrice;
  //ToDo remove transactionEvent
  final TransactionEvent onTransaction;
  final Function onError;

  WriteOnContractParams({
    required this.functionName,
    required this.args,
    required this.contract,
    required this.gasPrice,
    required this.eventName,
    required this.chainId,
    this.maxGas,
    required this.minGasPrice,
    required this.maxGasPrice,
    //ToDo remove transactionEvent
    required this.onTransaction,
    required this.onError,
  });

  WriteOnContractParams copyWith({
    String? functionName,
    List<dynamic>? args,
    DeployedContract? contract,
    int? gasPrice,
    String? eventName,
    int? chainId,
    int? maxGas,
    int? minGasPrice,
    int? maxGasPrice,
    //ToDo remove transactionEvent
    TransactionEvent? onTransaction,
    Function? onError,
  }) {
    return WriteOnContractParams(
      functionName: functionName ?? this.functionName,
      args: args ?? this.args,
      contract: contract ?? this.contract,
      gasPrice: gasPrice ?? this.gasPrice,
      eventName: eventName ?? this.eventName,
      chainId: chainId ?? this.chainId,
      maxGas: maxGas ?? this.maxGas,
      minGasPrice: minGasPrice ?? this.minGasPrice,
      maxGasPrice: maxGasPrice ?? this.maxGasPrice,
      onTransaction: onTransaction ?? this.onTransaction,
      onError: onError ?? this.onError,
    );
  }

  @override
  List<Object?> get props => [
        functionName,
        args,
        contract,
        gasPrice,
        eventName,
        chainId,
        maxGas,
        minGasPrice,
        maxGasPrice,
        onTransaction,
        onError,
      ];
}
