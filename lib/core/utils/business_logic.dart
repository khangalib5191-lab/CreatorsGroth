
class TaskCostCalculator {
  final double platformFeePercent;

  const TaskCostCalculator({this.platformFeePercent = 10});

  int totalCreditsRequired(int rewardPerParticipant, int participantCount) =>
      rewardPerParticipant * participantCount;

  int platformFee(int rewardPerParticipant, int participantCount) {
    final base = totalCreditsRequired(rewardPerParticipant, participantCount);
    return (base * platformFeePercent / 100).ceil();
  }

  int finalCost(int rewardPerParticipant, int participantCount) =>
      totalCreditsRequired(rewardPerParticipant, participantCount) +
      platformFee(rewardPerParticipant, participantCount);
}

class ReputationCalculator {
  static const approvedDelta = 2;
  static const rejectedDelta = -5;
  static const fraudReportDelta = -20;

  static int onProofApproved(int current) => current + approvedDelta;
  static int onProofRejected(int current) => current + rejectedDelta;
  static int onFraudReport(int current) => current + fraudReportDelta;
}

class UrlValidator {
  static bool isValidForPlatform(String url, String platform) {
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;

    return switch (platform) {
      'YouTube' =>
        uri.host.contains('youtube.com') || uri.host.contains('youtu.be'),
      'Instagram' => uri.host.contains('instagram.com'),
      'TikTok' => uri.host.contains('tiktok.com'),
      'Facebook' =>
        uri.host.contains('facebook.com') || uri.host.contains('fb.com'),
      'LinkedIn' => uri.host.contains('linkedin.com'),
      'X (Twitter)' =>
        uri.host.contains('twitter.com') || uri.host.contains('x.com'),
      _ => false,
    };
  }

  static String? extractContentId(String url, String platform) {
    if (!isValidForPlatform(url, platform)) return null;
    final uri = Uri.parse(url);

    return switch (platform) {
      'YouTube' => uri.queryParameters['v'] ??
          (uri.host.contains('youtu.be') ? uri.pathSegments.lastOrNull : null),
      'Instagram' => uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null,
      'TikTok' => uri.pathSegments.lastOrNull,
      _ => uri.path,
    };
  }

  static bool contentMatches(String originalUrl, String verificationUrl, String platform) {
    final originalId = extractContentId(originalUrl, platform);
    final verificationId = extractContentId(verificationUrl, platform);
    if (originalId == null || verificationId == null) return false;
    return originalId == verificationId;
  }
}

class VerificationEngine {
  static Map<String, dynamic> verify({
    required String taskLink,
    required String verificationUrl,
    required String platform,
    required bool alreadyCompleted,
    required Duration watchDuration,
    required Duration minimumWatchDuration,
    double fraudScore = 0,
  }) {
    final platformMatch = UrlValidator.isValidForPlatform(verificationUrl, platform);
    final contentMatch =
        UrlValidator.contentMatches(taskLink, verificationUrl, platform);
    final watchTimePass = watchDuration >= minimumWatchDuration;
    final duplicate = alreadyCompleted;
    final fraudLow = fraudScore < 50;

    final autoApprove = platformMatch &&
        contentMatch &&
        watchTimePass &&
        !duplicate &&
        fraudLow;

    String? rejectionReason;
    if (!platformMatch) {
      rejectionReason = 'Platform mismatch';
    } else if (!contentMatch) {
      rejectionReason = 'Content ID mismatch';
    } else if (!watchTimePass) {
      rejectionReason = 'Minimum watch time not met';
    } else if (duplicate) {
      rejectionReason = 'Task already completed';
    } else if (!fraudLow) {
      rejectionReason = 'High fraud score - under review';
    }

    return {
      'platform_match': platformMatch,
      'content_match': contentMatch,
      'watch_time_pass': watchTimePass,
      'duplicate': duplicate,
      'fraud_score': fraudScore,
      'auto_approve': autoApprove,
      'rejection_reason': rejectionReason,
      'trust_score': (100 - fraudScore).clamp(0, 100),
    };
  }
}
