enum TaskStatus {
  draft,
  pendingReview,
  active,
  inProgress,
  completed,
  closed,
}

enum ProofStatus { pending, underReview, approved, rejected }

extension TaskStatusX on TaskStatus {
  String get label => switch (this) {
        TaskStatus.draft => 'Draft',
        TaskStatus.pendingReview => 'Pending Review',
        TaskStatus.active => 'Active',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.completed => 'Completed',
        TaskStatus.closed => 'Closed',
      };

  String get apiValue => switch (this) {
        TaskStatus.draft => 'draft',
        TaskStatus.pendingReview => 'pending_review',
        TaskStatus.active => 'active',
        TaskStatus.inProgress => 'in_progress',
        TaskStatus.completed => 'completed',
        TaskStatus.closed => 'closed',
      };

  static TaskStatus fromString(String? value) => switch (value) {
        'pending_review' => TaskStatus.pendingReview,
        'active' => TaskStatus.active,
        'in_progress' => TaskStatus.inProgress,
        'completed' => TaskStatus.completed,
        'closed' => TaskStatus.closed,
        _ => TaskStatus.draft,
      };
}
