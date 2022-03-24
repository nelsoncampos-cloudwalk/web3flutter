import 'package:http/http.dart';
import 'package:get_it/get_it.dart';
import 'data/data_sources/web3_data_source.dart';
import 'data/repositories/web3_repository.dart';
import 'domain/repositories/web3_repository_impl.dart';
import 'domain/routines/read_contract_routine.dart';
import 'domain/routines/write_on_contract_routine.dart';
import 'domain/usecases/cancel_web3_transaction.dart';
import 'domain/usecases/deploy_contract.dart';
import 'domain/usecases/get_web3_balance.dart';
import 'domain/usecases/get_web3_transaction_count.dart';
import 'domain/usecases/get_web3_transaction_information.dart';
import 'domain/usecases/read_contract.dart';
import 'domain/usecases/write_on_contract.dart';
import 'infra/data_sources/web3_data_source_impl.dart';
import 'infra/service/web3_service.dart';
import '../core/injection_container.dart';

class Web3InjectionContainer extends InjectionContainer {
  final String publicKey;
  final String? privateKey;
  final String url;
  Web3InjectionContainer({
    required this.url,
    required this.publicKey,
    this.privateKey,
  });
  @override
  Future<void> inject(GetIt serviceLocator) async {
    _injectService(serviceLocator);
    _injectDataSource(serviceLocator);
    _injectRepository(serviceLocator);
    _injectUseCase(serviceLocator);
    _injectRoutines(serviceLocator);
  }

  Future<void> _injectService(GetIt serviceLocator) async {
    serviceLocator.registerLazySingleton<Web3Service>(
      () => Web3Service(
        client: Client(),
        publicKey: publicKey,
        url: url,
        privateKey: privateKey,
      ),
    );
  }

  Future<void> _injectDataSource(GetIt serviceLocator) async {
    serviceLocator.registerLazySingleton<Web3DataSource>(
      () => Web3DataSourceImpl(
        service: serviceLocator(),
      ),
    );
  }

  Future<void> _injectRepository(GetIt serviceLocator) async {
    serviceLocator.registerLazySingleton<Web3Repository>(
      () => Web3RepositoryImpl(
        dataSource: serviceLocator(),
      ),
    );
  }

  Future<void> _injectUseCase(GetIt serviceLocator) async {
    serviceLocator
      ..registerLazySingleton<CancelWeb3Transaction>(
        () => CancelWeb3TransactionImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<DeployContract>(
        () => DeployContractImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<GetWeb3Balance>(
        () => GetWeb3BalanceImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<GetWeb3TransactionCount>(
        () => GetWeb3TransactionCountImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<GetWeb3TransactionInformation>(
        () => GetWeb3TransactionInformationImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<ReadContract>(
        () => ReadContractImpl(repository: serviceLocator()),
      )
      ..registerLazySingleton<WriteOnContract>(
        () => WriteOnContractImpl(repository: serviceLocator()),
      );
  }

  Future<void> _injectRoutines(GetIt serviceLocator) async {
    serviceLocator
      ..registerLazySingleton<ReadContractRoutine>(
        () => ReadContractRoutineImpl(
          deployContract: serviceLocator(),
          readContract: serviceLocator(),
        ),
      )
      ..registerLazySingleton<WriteOnContractRoutine>(
        () => WriteOnContractRoutineImpl(
          deployContract: serviceLocator(),
          writeOnContract: serviceLocator(),
        ),
      );
  }
}
