import 'package:equatable/equatable.dart';

class RegisteredExtraFeeEntity extends Equatable {
  final String extraFeeId;
  final double amount;

  const RegisteredExtraFeeEntity({
    required this.extraFeeId,
    required this.amount,
  });

  @override
  List<Object?> get props => [extraFeeId, amount];
}
