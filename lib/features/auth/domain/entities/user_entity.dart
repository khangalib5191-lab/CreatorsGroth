import 'package:equatable/equatable.dart';
import '../../../../core/constants/roles.dart';

class AuthTokens extends Equatable {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt];
}

class SocialAccounts extends Equatable {
  final String? youtube;
  final String? instagram;
  final String? tiktok;
  final String? facebook;
  final String? linkedin;
  final String? twitter;

  const SocialAccounts({
    this.youtube,
    this.instagram,
    this.tiktok,
    this.facebook,
    this.linkedin,
    this.twitter,
  });

  @override
  List<Object?> get props =>
      [youtube, instagram, tiktok, facebook, linkedin, twitter];
}

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String niche;
  final String country;
  final String level;
  final String? bio;
  final String? profileImage;
  final String? coverImage;
  final String? website;
  final String? location;
  final List<String> platforms;
  final SocialAccounts socialAccounts;
  final int followers;
  final int following;
  final int credits;
  final int creditsSpent;
  final int creditsEarned;
  final int tasksCompleted;
  final int tasksCreated;
  final int reputationScore;
  final UserRole role;
  final bool isVerified;
  final bool isReviewer;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.niche,
    required this.country,
    required this.level,
    required this.platforms,
    required this.createdAt,
    this.bio,
    this.profileImage,
    this.coverImage,
    this.website,
    this.location,
    this.socialAccounts = const SocialAccounts(),
    this.followers = 0,
    this.following = 0,
    this.credits = 0,
    this.creditsSpent = 0,
    this.creditsEarned = 0,
    this.tasksCompleted = 0,
    this.tasksCreated = 0,
    this.reputationScore = 100,
    this.role = UserRole.user,
    this.isVerified = false,
    this.isReviewer = false,
  });

  UserEntity copyWith({
    String? fullName,
    String? username,
    String? bio,
    String? profileImage,
    String? coverImage,
    String? website,
    String? location,
    String? niche,
    String? country,
    String? level,
    List<String>? platforms,
    SocialAccounts? socialAccounts,
    int? followers,
    int? following,
    int? credits,
    int? creditsSpent,
    int? creditsEarned,
    int? tasksCompleted,
    int? tasksCreated,
    int? reputationScore,
    bool? isVerified,
  }) {
    return UserEntity(
      id: id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email,
      niche: niche ?? this.niche,
      country: country ?? this.country,
      level: level ?? this.level,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      coverImage: coverImage ?? this.coverImage,
      website: website ?? this.website,
      location: location ?? this.location,
      platforms: platforms ?? this.platforms,
      socialAccounts: socialAccounts ?? this.socialAccounts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      credits: credits ?? this.credits,
      creditsSpent: creditsSpent ?? this.creditsSpent,
      creditsEarned: creditsEarned ?? this.creditsEarned,
      tasksCompleted: tasksCompleted ?? this.tasksCompleted,
      tasksCreated: tasksCreated ?? this.tasksCreated,
      reputationScore: reputationScore ?? this.reputationScore,
      role: role,
      isVerified: isVerified ?? this.isVerified,
      isReviewer: isReviewer,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, email, credits, level, reputationScore];
}
