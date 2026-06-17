import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/presentation/app_notifiers.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/business_logic.dart';
import '../../core/utils/constants.dart';
import '../../core/theme/app_theme.dart';
import '../../features/task/domain/entities/task_entity.dart';

class CreateTaskScreen extends ConsumerStatefulWidget {
  const CreateTaskScreen({super.key});
  @override
  ConsumerState<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends ConsumerState<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _linkController = TextEditingController();
  final _instructionsController = TextEditingController();
  String _taskCategory = 'Growth';
  String _taskType = 'Watch Video';
  String _platform = 'YouTube';
  String _niche = 'Technology';
  int _reward = 10;
  int _participants = 50;
  bool _isSubmitting = false;

  late final TaskCostCalculator _calculator = TaskCostCalculator(
    platformFeePercent: AppConfig.platformFeePercent,
  );

  int get _totalCredits =>
      _calculator.totalCreditsRequired(_reward, _participants);
  int get _platformFee => _calculator.platformFee(_reward, _participants);
  int get _finalCost => _calculator.finalCost(_reward, _participants);

  @override
  void dispose() {
    _titleController.dispose();
    _linkController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _createTask() async {
    if (_titleController.text.isEmpty || _linkController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and task link are required')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final request = CreateTaskRequest(
      title: _titleController.text,
      description: _instructionsController.text.isNotEmpty
          ? _instructionsController.text
          : 'Complete the task to earn credits.',
      taskType: _taskType,
      platform: _platform,
      niche: _niche,
      taskLink: _linkController.text.trim(),
      thumbnail: '',
      rewardPerParticipant: _reward,
      participantCount: _participants,
      category: _taskCategory,
    );

    final error = await ref.read(taskNotifierProvider.notifier).createTask(request);
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user!;
    final canAfford = user.credits >= _finalCost;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Credits',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        '${user.credits}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 40,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              initialValue: _taskCategory,
              decoration: const InputDecoration(
                labelText: 'Task Category',
                prefixIcon: Icon(Icons.folder),
              ),
              items: AppConstants.taskCategories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _taskCategory = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              initialValue: _taskType,
              decoration: const InputDecoration(
                labelText: 'Task Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: AppConstants.taskTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _taskType = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              initialValue: _platform,
              decoration: const InputDecoration(
                labelText: 'Platform',
                prefixIcon: Icon(Icons.devices),
              ),
              items: AppConstants.platforms
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _platform = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              initialValue: _niche,
              decoration: const InputDecoration(
                labelText: 'Niche',
                prefixIcon: Icon(Icons.label),
              ),
              items: AppConstants.niches
                  .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                  .toList(),
              onChanged: (v) => setState(() => _niche = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Target Link',
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _instructionsController,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            Text(
              'Reward Per Participant: $_reward credits',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _reward.toDouble(),
              min: 5,
              max: 100,
              divisions: 19,
              onChanged: (v) => setState(() => _reward = v.round()),
            ),
            Text('Participants: $_participants'),
            Slider(
              value: _participants.toDouble(),
              min: 10,
              max: 500,
              divisions: 49,
              onChanged: (v) => setState(() => _participants = v.round()),
            ),
            const SizedBox(height: 16),
            _costRow('Task Cost', '$_totalCredits credits'),
            _costRow('Platform Fee (${AppConfig.platformFeePercent.toInt()}%)',
                '$_platformFee credits'),
            _costRow('Escrow Lock (Total)', '$_finalCost credits', bold: true),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: canAfford && !_isSubmitting ? _createTask : null,
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(canAfford ? 'Create Task' : 'Insufficient Credits'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                )),
            Text(value,
                style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                )),
          ],
        ),
      );
}
