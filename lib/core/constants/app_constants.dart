class AppConstants {
  static const String appName = 'GroCal';
  static const String appTagline = 'Growth + Circle';

  static List<String> get niches => [
        'Gaming',
        'Technology',
        'AI',
        'Programming',
        'Business',
        'Finance',
        'Education',
        'Travel',
        'Photography',
        'Lifestyle',
        'Fitness',
        'Food',
        'Marketing',
        'Freelancing',
        'E-Commerce',
        'Other',
      ];

  static List<String> get platforms =>
      ['YouTube', 'Instagram', 'TikTok', 'Facebook', 'LinkedIn', 'X (Twitter)'];

  static List<String> get taskTypes => [
        'Watch Video',
        'Watch Reel',
        'Watch Short',
        'View Image',
        'Visit Profile',
        'Follow User',
        'Like Post',
        'Comment on Post',
        'Subscribe Channel',
        'Like Content',
        'Comment Content',
      ];

  static List<String> get taskCategories =>
      ['Growth', 'Engagement', 'Promotion', 'Research', 'Review'];

  static List<String> get countries => [
        'All Countries',
        'United States',
        'United Kingdom',
        'Canada',
        'Australia',
        'India',
        'Pakistan',
      ];

  static List<String> get communityCategories => [
        'YouTube',
        'TikTok',
        'Instagram',
        'Facebook',
        'Freelancing',
        'Business',
        'AI',
        'Technology',
      ];

  static List<String> get communityTypes =>
      ['Public', 'Private', 'Invite Only'];

  static List<String> get memberRoles =>
      ['Owner', 'Admin', 'Moderator', 'Member'];

  static List<String> get reportReasons => [
        'Spam',
        'Harassment',
        'Fraud',
        'Inappropriate Content',
        'Fake Account',
        'Other',
      ];
}

class CreatorLevel {
  static const beginner = 'Beginner';
  static const bronze = 'Bronze';
  static const silver = 'Silver';
  static const gold = 'Gold';
  static const platinum = 'Platinum';

  /// Level thresholds per project spec (based on lifetime credits earned).
  static String fromCreditsEarned(int creditsEarned) {
    if (creditsEarned >= 50000) return platinum;
    if (creditsEarned >= 15000) return gold;
    if (creditsEarned >= 5000) return silver;
    if (creditsEarned >= 1000) return bronze;
    return beginner;
  }

  @Deprecated('Use fromCreditsEarned instead')
  static String getLevelFromPoints(int points) => fromCreditsEarned(points);
}
