import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../widgets/creator_card_widget.dart';
import '../../widgets/task_card_widget.dart';
import '../../widgets/community_card_widget.dart';

class NichePage extends ConsumerWidget {
  final String niche;
  const NichePage({super.key, required this.niche});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creators = ref
        .watch(authNotifierProvider.notifier)
        .suggestedCreators
        .where((u) => u.niche == niche)
        .toList();
    final tasks =
        ref.watch(taskNotifierProvider).tasks.where((t) => t.niche == niche).toList();
    final communities = ref
        .watch(communityNotifierProvider)
        .communities
        .where((c) => c.category == niche)
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('$niche Creators')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Creators',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (creators.isEmpty)
              const Text('No creators available in this niche yet.')
            else
              Column(
                children: creators
                    .map(
                      (creator) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CreatorCardWidget(creator: creator),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            Text(
              'Trending Tasks',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (tasks.isEmpty)
              const Text('No tasks available for this niche yet.')
            else
              Column(
                children: tasks
                    .map(
                      (task) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCardWidget(task: task),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            Text(
              'Popular Communities',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (communities.isEmpty)
              const Text('No communities available for this niche yet.')
            else
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: communities.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: CommunityCardWidget(
                      community: communities[index],
                      width: 240,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
