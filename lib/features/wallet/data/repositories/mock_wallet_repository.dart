import '../../../../core/utils/result.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

class MockWalletRepository implements WalletRepository {
  final MockAuthRepository authRepository;
  final List<CreditTransaction> _transactions = [];

  MockWalletRepository({required this.authRepository}) {
    _seedTransactions();
  }

  void _seedTransactions() {
    _transactions.addAll([
      CreditTransaction(
        id: 'tx_1',
        type: CreditTransactionType.earned,
        amount: 15,
        reason: 'Task completed: Watch Video',
        referenceId: 'task_1',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CreditTransaction(
        id: 'tx_2',
        type: CreditTransactionType.spent,
        amount: 50,
        reason: 'Task created: Tech Review',
        referenceId: 'task_3',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      CreditTransaction(
        id: 'tx_3',
        type: CreditTransactionType.earned,
        amount: 500,
        reason: 'Welcome Bonus',
        referenceId: 'welcome_bonus',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
    ]);
  }

  @override
  Future<Result<WalletEntity>> getWallet(String userId) async {
    final user = authRepository.currentUserInternal;
    if (user == null || user.id != userId) {
      return const Error('Wallet not found');
    }
    return Success(WalletEntity(
      currentCredits: user.credits,
      lifetimeEarned: user.creditsEarned,
      lifetimeSpent: user.creditsSpent,
    ));
  }

  @override
  Future<Result<List<CreditTransaction>>> getTransactions(String userId,
      {int page = 1}) async {
    return Success(_transactions);
  }

  @override
  Future<Result<void>> lockEscrow(
      String userId, int amount, String referenceId) async {
    _transactions.insert(
      0,
      CreditTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: CreditTransactionType.escrowLock,
        amount: amount,
        reason: 'Escrow locked for task',
        referenceId: referenceId,
        createdAt: DateTime.now(),
      ),
    );
    return const Success(null);
  }

  @override
  Future<Result<void>> releaseEscrow(
      String userId, int amount, String referenceId) async {
    _transactions.insert(
      0,
      CreditTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: CreditTransactionType.escrowRelease,
        amount: amount,
        reason: 'Escrow released',
        referenceId: referenceId,
        createdAt: DateTime.now(),
      ),
    );
    return const Success(null);
  }

  @override
  Future<Result<void>> creditUser(
      String userId, int amount, String reason, String referenceId) async {
    _transactions.insert(
      0,
      CreditTransaction(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        type: CreditTransactionType.earned,
        amount: amount,
        reason: reason,
        referenceId: referenceId,
        createdAt: DateTime.now(),
      ),
    );
    return const Success(null);
  }
}
