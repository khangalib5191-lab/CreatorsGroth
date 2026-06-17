import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';

class MessagesScreen extends ConsumerWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chats = ref.watch(chatNotifierProvider).chats;

    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: chats.isEmpty
          ? const Center(child: Text('No messages yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: chats.length,
              itemBuilder: (ctx, i) {
                final chat = chats[i];
                return ListTile(
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRouter.chat,
                    arguments: {
                      'chatId': chat.id,
                      'userName': chat.userName,
                    },
                  ),
                  leading: CircleAvatar(
                    backgroundImage: chat.userImage != null
                        ? NetworkImage(chat.userImage!)
                        : null,
                  ),
                  title: Text(
                    chat.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: chat.unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
    );
  }
}
