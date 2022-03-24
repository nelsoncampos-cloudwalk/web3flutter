import 'package:equatable/equatable.dart';
import 'package:web3dart/web3dart.dart';

class GetBalanceParams extends Equatable {
  final EtherUnit unit;
  final BlockNum? atBlock;

  const GetBalanceParams({
    this.unit = EtherUnit.ether,
    this.atBlock,
  });

  @override
  List<Object?> get props => [
        unit,
        atBlock,
      ];
}
