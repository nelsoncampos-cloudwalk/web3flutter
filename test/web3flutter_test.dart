import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3flutter/src/web3flutter.dart';

class Web3ClientMock extends Mock implements Web3Client {}

void main() {
  late Web3ClientMock web3client;
  late Web3Flutter web3flutter;
  setUp(() {
    web3client = Web3ClientMock();
    web3flutter = Web3Flutter(
      web3: web3client,
      publicKey: '',
    );
  });

  group('Public key to Address', () {
    test('SUCCESS', () {
      //? arrange
      final address = web3flutter.address;
      //* act

      //! assert
      expect(
        address.hex.toLowerCase(),
        '0x322c6e06F78C141d93dFFc5255EA69cAf15Fb6af'.toLowerCase(),
      );
    });
  });
}
