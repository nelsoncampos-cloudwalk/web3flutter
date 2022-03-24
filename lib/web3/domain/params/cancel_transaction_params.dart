import 'package:equatable/equatable.dart';

class CancelTransactionParams extends Equatable {
  final int nonce;
  final int gasPrice;
  final int? maxGas;
  final int chainId;
  final String transactionHash;

  const CancelTransactionParams({
    required this.nonce,
    required this.gasPrice,
    required this.transactionHash,
    this.maxGas,
    this.chainId = 4,
  });

  @override
  List<Object?> get props => [
        nonce,
        gasPrice,
        transactionHash,
        maxGas,
      ];
}
