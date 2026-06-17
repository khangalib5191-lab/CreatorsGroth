import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String userName;
  const ChatScreen({super.key, required this.chatId, required this.userName});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _controller = TextEditingController();
  List messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded =
        await ref.read(chatNotifierProvider.notifier).getMessages(widget.chatId);
    if (mounted) {
      setState(() {
        messages = loaded;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_controller.text.isEmpty) return;
    final userId = ref.read(authNotifierProvider).user!.id;
    await ref.read(chatNotifierProvider.notifier).sendMessage(
          widget.chatId,
          _controller.text,
          userId,
        );
    _controller.clear();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(authNotifierProvider).user?.id;

    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (ctx, i) {
                      final m = messages[i];
                      final isMe = m.senderId == userId;
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? AppTheme.primaryColor
                                : AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            m.content,
                            style: TextStyle(
                              color: isMe ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send), onPressed: _send),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
