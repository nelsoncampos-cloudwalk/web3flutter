import 'package:dartz/dartz.dart';
import 'package:web3dart/web3dart.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class GetWeb3TransactionInformation {
  Future<Either<Failure, TransactionInformation>> call({
    required String transactionHash,
  });
}

class GetWeb3TransactionInformationImpl
    implements GetWeb3TransactionInformation {
  final Web3Repository repository;

  GetWeb3TransactionInformationImpl({required this.repository});

  @override
  Future<Either<Failure, TransactionInformation>> call({
    required String transactionHash,
  }) async {
    return repository.getTransactionInformation(
      transactionHash: transactionHash,
    );
  }
}
