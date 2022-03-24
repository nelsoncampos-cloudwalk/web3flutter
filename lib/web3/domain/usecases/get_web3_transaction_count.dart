import 'package:dartz/dartz.dart';
import 'package:web3dart/web3dart.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class GetWeb3TransactionCount {
  Future<Either<Failure, int>> call({
    BlockNum? atBlock,
  });
}

class GetWeb3TransactionCountImpl implements GetWeb3TransactionCount {
  final Web3Repository repository;

  GetWeb3TransactionCountImpl({required this.repository});

  @override
  Future<Either<Failure, int>> call({
    BlockNum? atBlock,
  }) async {
    return repository.getTransactionCount(atBlock: atBlock);
  }
}
