import 'package:dartz/dartz.dart';
import '../../data/repositories/web3_repository.dart';
import '../params/cancel_transaction_params.dart';
import '../../../errors/failure.dart';

abstract class CancelWeb3Transaction {
  Future<Either<Failure, String>> call({
    required CancelTransactionParams params,
  });
}

class CancelWeb3TransactionImpl implements CancelWeb3Transaction {
  final Web3Repository repository;

  CancelWeb3TransactionImpl({required this.repository});

  @override
  Future<Either<Failure, String>> call({
    required CancelTransactionParams params,
  }) async {
    return repository.cancelTransaction(params: params);
  }
}
