import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../app/presentation/app_notifiers.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';

class CreditCardWidget extends ConsumerWidget {
  const CreditCardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Credits',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${user.credits}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMiniStat(context, 'Earned', '${user.creditsEarned}'),
                  const SizedBox(width: 16),
                  _buildMiniStat(context, 'Spent', '${user.creditsSpent}'),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRouter.creditHistory),
            icon: const Icon(Icons.history, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(BuildContext context, String label, String value) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      );
}
