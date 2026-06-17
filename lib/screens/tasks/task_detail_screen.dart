import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_router.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskNotifierProvider).tasks;
    final task = tasks.firstWhere((t) => t.id == taskId);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (task.thumbnail.isNotEmpty)
                    Image.network(task.thumbnail, fit: BoxFit.cover)
                  else
                    Container(color: AppTheme.primaryColor),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${task.reward} Credits',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.profile,
                          arguments: {'userId': task.creatorId},
                        ),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: task.creatorImage != null
                              ? NetworkImage(task.creatorImage!)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.profile,
                          arguments: {'userId': task.creatorId},
                        ),
                        child: Text(task.creatorName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(label: Text(task.category)),
                      const SizedBox(width: 8),
                      Chip(label: Text(task.niche)),
                      const SizedBox(width: 8),
                      Chip(label: Text(task.taskType)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(task.description),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: task.completionPercentage / 100,
                      backgroundColor: AppTheme.backgroundColor,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${task.participantsCompleted}/${task.participantsNeeded} completed',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRouter.submitProof,
                        arguments: {'taskId': task.id},
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Complete & Submit Proof'),
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
}
