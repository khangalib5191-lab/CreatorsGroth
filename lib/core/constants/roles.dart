enum UserRole { user, moderator, admin, superAdmin }

extension UserRoleX on UserRole {
  String get value => switch (this) {
        UserRole.user => 'user',
        UserRole.moderator => 'moderator',
        UserRole.admin => 'admin',
        UserRole.superAdmin => 'super_admin',
      };

  static UserRole fromString(String? value) => switch (value) {
        'moderator' => UserRole.moderator,
        'admin' => UserRole.admin,
        'super_admin' => UserRole.superAdmin,
        _ => UserRole.user,
      };

  bool get isStaff =>
      this == UserRole.moderator ||
      this == UserRole.admin ||
      this == UserRole.superAdmin;

  bool get isAdmin => this == UserRole.admin || this == UserRole.superAdmin;
}

class Permissions {
  static bool canPostInAdminCommunity(UserRole role) => role.isAdmin;
  static bool canModerateTasks(UserRole role) => role.isStaff;
  static bool canManageCommunity(UserRole role, String memberRole) =>
      role.isStaff || memberRole == 'owner' || memberRole == 'admin';
}
