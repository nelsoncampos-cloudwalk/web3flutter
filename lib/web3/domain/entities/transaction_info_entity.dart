import 'package:equatable/equatable.dart';

class TransactionInfo extends Equatable {
  final int nonce;
  final int gasPrice;
  final int? maxGas;
  final String transactionHash;

  const TransactionInfo({
    required this.nonce,
    required this.gasPrice,
    required this.transactionHash,
    this.maxGas,
  });

  @override
  List<Object?> get props => [
        nonce,
        gasPrice,
        transactionHash,
        maxGas,
      ];
}
