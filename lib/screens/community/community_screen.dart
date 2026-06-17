import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../widgets/community_card_widget.dart';
import 'groups_page.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});
  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityNotifierProvider);
    final chatState = ref.watch(chatNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Feed'),
            Tab(text: 'Communities'),
            Tab(text: 'Groups'),
            Tab(text: 'Chat')
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            tooltip: 'Admin Guidance',
            onPressed: () => Navigator.pushNamed(context, AppRouter.adminGroup),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedTab(context, communityState.posts),
          _buildCommunitiesTab(context, communityState.communities),
          const GroupsPage(),
          _buildChatTab(context, chatState.chats),
        ],
      ),
    );
  }

  Widget _buildFeedTab(BuildContext context, List posts) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      itemBuilder: (ctx, i) {
        final post = posts[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, AppRouter.profile,
                          arguments: {'userId': post.userId}),
                      child: CircleAvatar(
                          backgroundImage: post.userImage != null
                              ? NetworkImage(post.userImage!)
                              : null)),
                  const SizedBox(width: 12),
                  InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, AppRouter.profile,
                          arguments: {'userId': post.userId}),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(_formatTime(post.createdAt),
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12)),
                          ])),
                ]),
                const SizedBox(height: 12),
                Text(post.content),
                const SizedBox(height: 12),
                Row(children: [
                  const Icon(Icons.favorite_border,
                      color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text('${post.likesCount}'),
                  const SizedBox(width: 24),
                  InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.comments,
                      arguments: {'postId': post.id, 'post': post},
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline,
                            color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text('${post.commentsCount}'),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommunitiesTab(BuildContext context, List communities) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85),
      itemCount: communities.length,
      itemBuilder: (ctx, i) =>
          CommunityCardWidget(community: communities[i]),
    );
  }

  Widget _buildChatTab(BuildContext context, List chats) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chats.length,
      itemBuilder: (ctx, i) {
        final chat = chats[i];
        return ListTile(
          onTap: () => Navigator.pushNamed(context, AppRouter.chat,
              arguments: {'chatId': chat.id, 'userName': chat.userName}),
          leading: CircleAvatar(
              backgroundImage: chat.userImage != null
                  ? NetworkImage(chat.userImage!)
                  : null),
          title: Text(chat.userName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(chat.lastMessage,
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(_formatTime(chat.lastMessageTime),
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        );
      },
    );
  }

  String _formatTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
