import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/roles.dart';
import '../../domain/entities/user_entity.dart';

class UserDto {
  final Map<String, dynamic> json;

  UserDto(this.json);

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(json);

  Map<String, dynamic> toJson() => json;

  UserEntity toEntity() {
    final social = json['social_accounts'] as Map<String, dynamic>? ?? {};
    return UserEntity(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      niche: json['niche']?.toString() ?? 'Other',
      country: json['country']?.toString() ?? 'United States',
      level: json['level']?.toString() ??
          CreatorLevel.fromCreditsEarned(json['credits_earned'] ?? 0),
      bio: json['bio']?.toString(),
      profileImage: json['profile_image']?.toString(),
      coverImage: json['cover_image']?.toString(),
      website: json['website']?.toString(),
      location: json['location']?.toString(),
      platforms: List<String>.from(json['platforms'] ?? []),
      socialAccounts: SocialAccounts(
        youtube: social['youtube']?.toString(),
        instagram: social['instagram']?.toString(),
        tiktok: social['tiktok']?.toString(),
        facebook: social['facebook']?.toString(),
        linkedin: social['linkedin']?.toString(),
        twitter: social['twitter']?.toString(),
      ),
      followers: json['followers'] ?? 0,
      following: json['following'] ?? 0,
      credits: json['credits'] ?? 0,
      creditsSpent: json['credits_spent'] ?? 0,
      creditsEarned: json['credits_earned'] ?? 0,
      tasksCompleted: json['tasks_completed'] ?? 0,
      tasksCreated: json['tasks_created'] ?? 0,
      reputationScore: json['reputation_score'] ?? 100,
      role: UserRoleX.fromString(json['role']?.toString()),
      isVerified: json['is_verified'] == true,
      isReviewer: json['is_reviewer'] == true,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  static Map<String, dynamic> fromEntity(UserEntity entity) => {
        'id': entity.id,
        'full_name': entity.fullName,
        'username': entity.username,
        'email': entity.email,
        'niche': entity.niche,
        'country': entity.country,
        'level': entity.level,
        'bio': entity.bio,
        'profile_image': entity.profileImage,
        'cover_image': entity.coverImage,
        'website': entity.website,
        'location': entity.location,
        'platforms': entity.platforms,
        'followers': entity.followers,
        'following': entity.following,
        'credits': entity.credits,
        'credits_spent': entity.creditsSpent,
        'credits_earned': entity.creditsEarned,
        'tasks_completed': entity.tasksCompleted,
        'tasks_created': entity.tasksCreated,
        'reputation_score': entity.reputationScore,
        'role': entity.role.value,
        'is_verified': entity.isVerified,
        'is_reviewer': entity.isReviewer,
        'created_at': entity.createdAt.toIso8601String(),
      };
}
