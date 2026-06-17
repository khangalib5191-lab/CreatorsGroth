import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationNotifierProvider);
    final notifier = ref.read(notificationNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => notifier.markAllAsRead(),
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: state.notifications.isEmpty
          ? const Center(child: Text('No notifications'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.notifications.length,
              itemBuilder: (ctx, i) {
                final n = state.notifications[i];
                return Card(
                  color: n.isRead
                      ? null
                      : AppTheme.primaryColor.withValues(alpha: 0.05),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    onTap: () => notifier.markAsRead(n.id),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_getIcon(n.type), color: Colors.white),
                    ),
                    title: Text(
                      n.title,
                      style: TextStyle(
                        fontWeight:
                            n.isRead ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(n.message, maxLines: 2),
                  ),
                );
              },
            ),
    );
  }

  IconData _getIcon(String type) => switch (type) {
        'follow' => Icons.person_add,
        'taskApproved' => Icons.stars,
        'comment' => Icons.comment,
        _ => Icons.notifications,
      };
}
