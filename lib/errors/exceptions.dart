import 'package:equatable/equatable.dart';
import 'package:web3flutter/errors/failure.dart';

class Web3Exception extends Equatable implements Exception {
  final int? code;
  final String? title;
  final String? message;
  final Map<String, dynamic>? extraData;

  const Web3Exception({
    this.code,
    this.message,
    this.title,
    this.extraData,
  });

  @override
  String toString() {
    return 'code: $code;\ntitle: $title;\nmessage: $message;\nextraData: $extraData;';
  }

  Failure toFailure() => Failure(
        code: code,
        message: message,
        title: title,
        extraData: extraData,
      );

  @override
  List<Object?> get props => [
        code,
        title,
        message,
        extraData,
      ];
}
