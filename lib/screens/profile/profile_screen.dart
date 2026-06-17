import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../core/models/user_model.dart';

class ProfileScreen extends ConsumerWidget {
  final UserModel? user;
  final String? userId;

  const ProfileScreen({
    super.key,
    this.user,
    this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).user!;
    final displayedUser = user ??
        (userId != null
            ? ref.watch(authNotifierProvider.notifier).getUserById(userId!) ??
                currentUser
            : currentUser);
    final isCurrentUser = displayedUser.id == currentUser.id;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            actions: [
              if (isCurrentUser)
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRouter.settingsRoute,
                  ),
                ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: displayedUser.profileImage != null
                            ? NetworkImage(displayedUser.profileImage!)
                            : null,
                        child: displayedUser.profileImage == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            displayedUser.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (displayedUser.isVerified) ...[
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.verified,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        '@${displayedUser.username.replaceAll('@', '')}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          displayedUser.level,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        context,
                        displayedUser.followers,
                        'Followers',
                      ),
                      _buildStat(
                        context,
                        displayedUser.following,
                        'Following',
                      ),
                      _buildStat(
                        context,
                        displayedUser.points,
                        'Points',
                      ),
                      _buildStat(
                        context,
                        displayedUser.tasksCompleted,
                        'Tasks',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isCurrentUser)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRouter.editProfile,
                        ),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Profile'),
                      ),
                    ),
                  if (isCurrentUser) const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Achievements',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildBadge(
                              context,
                              'Early Adopter',
                              true,
                            ),
                            _buildBadge(
                              context,
                              'First Task',
                              true,
                            ),
                            _buildBadge(
                              context,
                              'Pro Reviewer',
                              displayedUser.reviewerTrustLevel >= 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, int value, String label) {
    return Column(
      children: [
        Text(
          _formatNum(value),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(
    BuildContext context,
    String title,
    bool unlocked,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: unlocked ? AppTheme.primaryColor : AppTheme.textLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: unlocked ? AppTheme.textPrimary : AppTheme.textHint,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    return n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : n.toString();
  }
}
