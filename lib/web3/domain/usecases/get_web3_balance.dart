import 'package:dartz/dartz.dart';
import '../params/get_balance_params.dart';
import '../../data/repositories/web3_repository.dart';
import '../../../errors/failure.dart';

abstract class GetWeb3Balance {
  Future<Either<Failure, double>> call({
    required GetBalanceParams params,
  });
}

class GetWeb3BalanceImpl implements GetWeb3Balance {
  final Web3Repository repository;

  GetWeb3BalanceImpl({required this.repository});

  @override
  Future<Either<Failure, double>> call({
    required GetBalanceParams params,
  }) async {
    return repository.getBalance(params: params);
  }
}
