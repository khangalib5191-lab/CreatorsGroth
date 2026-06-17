import '../../../../core/utils/result.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Result<WalletEntity>> getWallet(String userId);
  Future<Result<List<CreditTransaction>>> getTransactions(String userId, {int page = 1});
  Future<Result<void>> lockEscrow(String userId, int amount, String referenceId);
  Future<Result<void>> releaseEscrow(String userId, int amount, String referenceId);
  Future<Result<void>> creditUser(String userId, int amount, String reason, String referenceId);
}
