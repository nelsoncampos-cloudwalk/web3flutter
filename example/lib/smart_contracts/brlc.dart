import 'package:web3flutter/web3flutter.dart';

class Brlc {
  final String contractName = "TransparentUpgradeableProxy";
  final String address = "0xA9a55a81a4C085EC0C31585Aed4cFB09D78dfD53";
  final String abiPath = "assets/abi/brlc.json";
  final Web3Flutter web3;
  late final DeployedContract contract;

  Brlc({required this.web3}) {
    deployContract();
  }

  Future<void> deployContract() async {
    contract = await web3.deployContract(
      abiPath: abiPath,
      contractName: contractName,
      contractAddress: address,
    );
  }

  Future<double> getGames({required double gameId}) async {
    final contractResult = await web3.readContract(
      'getGames',
      [gameId],
      contract: contract,
    );
    final resultInBigInt = (contractResult as List<dynamic>).first as BigInt;
    return resultInBigInt.toInt() / 1000000;
  }
}
