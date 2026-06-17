import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/theme/app_theme.dart';

class SubmitProofScreen extends ConsumerStatefulWidget {
  final String taskId;
  const SubmitProofScreen({super.key, required this.taskId});

  @override
  ConsumerState<SubmitProofScreen> createState() => _SubmitProofScreenState();
}

class _SubmitProofScreenState extends ConsumerState<SubmitProofScreen> {
  final _linkController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_linkController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification URL is required')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final error = await ref.read(taskNotifierProvider.notifier).submitProof(
          taskId: widget.taskId,
          verificationUrl: _linkController.text.trim(),
          watchDuration: const Duration(minutes: 5),
        );
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proof submitted successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = ref
        .watch(taskNotifierProvider)
        .tasks
        .firstWhere((t) => t.id == widget.taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Submit Verification')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task: ${task.title}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Reward: ${task.reward} credits',
              style: const TextStyle(
                color: AppTheme.accentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Verification URL',
                prefixIcon: Icon(Icons.link),
                hintText: 'Paste the content URL after completing the task',
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'System verifies platform match, content ID, watch time, and duplicate detection.',
                style: TextStyle(color: AppTheme.infoColor, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit Verification'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
