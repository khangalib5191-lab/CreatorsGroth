import 'package:flutter/material.dart';
import '../core/models/task_model.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';

class ReviewCardWidget extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const ReviewCardWidget(
      {super.key,
      required this.task,
      required this.onApprove,
      required this.onReject});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, AppRouter.profile,
                        arguments: {'userId': task.creatorId}),
                    child: CircleAvatar(
                        backgroundImage: task.creatorImage != null
                            ? NetworkImage(task.creatorImage!)
                            : null),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, AppRouter.profile,
                          arguments: {'userId': task.creatorId}),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(task.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(task.creatorName,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(task.platform,
                        style: const TextStyle(
                            color: AppTheme.primaryColor, fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 12),
              const Text('Submitted proof available for review.',
                  style: TextStyle(color: AppTheme.textSecondary)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor),
                    child: const Text('Reject'),
                  ),
                ),
              ])
            ],
          ),
        ),
      );
}
