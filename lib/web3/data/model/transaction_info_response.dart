import 'package:equatable/equatable.dart';
import 'package:web3flutter/web3/domain/entities/transaction_info_entity.dart';

class TransactionInfoResponse extends Equatable {
  final int nonce;
  final int gasPrice;
  final int? maxGas;
  final String transactionHash;

  const TransactionInfoResponse({
    required this.nonce,
    required this.gasPrice,
    required this.transactionHash,
    this.maxGas,
  });

  factory TransactionInfoResponse.fromEntity(TransactionInfo entity) {
    return TransactionInfoResponse(
      nonce: entity.nonce,
      gasPrice: entity.gasPrice,
      transactionHash: entity.transactionHash,
      maxGas: entity.maxGas,
    );
  }

  TransactionInfo parseToEntity() {
    return TransactionInfo(
      nonce: nonce,
      gasPrice: gasPrice,
      transactionHash: transactionHash,
      maxGas: maxGas,
    );
  }

  @override
  List<Object?> get props => [
        nonce,
        gasPrice,
        transactionHash,
        maxGas,
      ];
}
