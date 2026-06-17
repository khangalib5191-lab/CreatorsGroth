import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';
import '../../core/models/community_model.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final String postId;
  final PostModel post;

  const CommentsPage({super.key, required this.postId, required this.post});

  @override
  ConsumerState<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  List<CommentModel> comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final loaded =
        await ref.read(communityNotifierProvider.notifier).getComments(widget.postId);
    if (mounted) {
      setState(() {
        comments = loaded;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;

    final currentUser = ref.read(authNotifierProvider).user;

    // FIX: Null safety check
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to comment')),
      );
      return;
    }

    final newComment = CommentModel(
      id: 'comment_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.postId,
      userId: currentUser.id,
      userName: currentUser.fullName,
      userImage: currentUser.profileImage,
      content: _commentController.text.trim(),
      likesCount: 0,
      createdAt: DateTime.now(),
    );

    setState(() {
      comments.insert(0, newComment);
      _commentController.clear();
    });
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Original post preview
                Card(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, AppRouter.profile,
                                  arguments: {'userId': widget.post.userId}),
                              child: CircleAvatar(
                                backgroundImage: widget.post.userImage != null
                                    ? NetworkImage(widget.post.userImage!)
                                    : null,
                                child: widget.post.userImage == null
                                    ? const Icon(Icons.person, size: 20)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(
                                    context, AppRouter.profile,
                                    arguments: {'userId': widget.post.userId}),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.post.userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12)),
                                    Text(_formatTime(widget.post.createdAt),
                                        style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 10)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(widget.post.content,
                            style: const TextStyle(fontSize: 12)),
                        const Divider(height: 16),
                        Row(
                          children: [
                            Text('${widget.post.likesCount} Likes',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary)),
                            const SizedBox(width: 16),
                            Text('${comments.length} Comments',
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Comments list
                ...comments.map((comment) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, AppRouter.profile,
                                arguments: {'userId': comment.userId}),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: comment.userImage != null
                                  ? NetworkImage(comment.userImage!)
                                  : null,
                              child: comment.userImage == null
                                  ? const Icon(Icons.person, size: 18)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.backgroundColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.pushNamed(
                                            context, AppRouter.profile,
                                            arguments: {
                                              'userId': comment.userId
                                            }),
                                        child: Text(comment.userName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12)),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(comment.content,
                                          style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(_formatTime(comment.createdAt),
                                        style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 10)),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.favorite_border,
                                            size: 12,
                                            color: AppTheme.textSecondary),
                                        const SizedBox(width: 4),
                                        Text('${comment.likesCount}',
                                            style: const TextStyle(
                                                color: AppTheme.textSecondary,
                                                fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          // Comment input box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.backgroundColor)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      hintStyle: const TextStyle(color: AppTheme.textSecondary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.backgroundColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppTheme.primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _addComment,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}