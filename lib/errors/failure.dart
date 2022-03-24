import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final int? code;
  final String? title;
  final String? message;
  final Map<String, dynamic>? extraData;

  const Failure({
    this.code,
    this.title,
    this.message,
    this.extraData,
  });

  @override
  List<Object?> get props => [
        code,
        title,
        message,
        extraData,
      ];
}
