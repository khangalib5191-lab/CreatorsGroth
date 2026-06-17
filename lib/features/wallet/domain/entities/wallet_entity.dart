import 'package:equatable/equatable.dart';

enum CreditTransactionType { earned, spent, transferred, escrowLock, escrowRelease }

class CreditTransaction extends Equatable {
  final String id;
  final CreditTransactionType type;
  final int amount;
  final String reason;
  final String? referenceId;
  final DateTime createdAt;

  const CreditTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.reason,
    this.referenceId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}

class WalletEntity extends Equatable {
  final int currentCredits;
  final int lifetimeEarned;
  final int lifetimeSpent;
  final int escrowBalance;

  const WalletEntity({
    required this.currentCredits,
    required this.lifetimeEarned,
    required this.lifetimeSpent,
    this.escrowBalance = 0,
  });

  @override
  List<Object?> get props =>
      [currentCredits, lifetimeEarned, lifetimeSpent, escrowBalance];
}
