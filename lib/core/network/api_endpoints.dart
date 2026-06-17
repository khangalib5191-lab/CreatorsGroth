class ApiEndpoints {
  static const authLogin = '/auth/login';
  static const authRegister = '/auth/register';
  static const authLogout = '/auth/logout';
  static const authRefresh = '/auth/refresh';
  static const authForgotPassword = '/auth/forgot-password';
  static const authVerifyEmail = '/auth/verify-email';
  static const authMe = '/auth/me';

  static const users = '/users';
  static String user(String id) => '/users/$id';
  static String followUser(String id) => '/users/$id/follow';
  static String blockUser(String id) => '/users/$id/block';
  static String reportUser(String id) => '/users/$id/report';

  static const tasks = '/tasks';
  static String task(String id) => '/tasks/$id';
  static String taskProofs(String id) => '/tasks/$id/proofs';
  static String taskSession(String id) => '/tasks/$id/sessions';
  static const myTasks = '/tasks/my';
  static const marketplaceTasks = '/tasks/marketplace';

  static const communities = '/communities';
  static String community(String id) => '/communities/$id';
  static String joinRequests(String id) => '/communities/$id/join-requests';

  static const chats = '/chats';
  static String chatMessages(String id) => '/chats/$id/messages';
  static const groups = '/groups';
  static String groupMessages(String id) => '/groups/$id/messages';

  static const notifications = '/notifications';
  static const wallet = '/wallet';
  static const walletTransactions = '/wallet/transactions';
  static const search = '/search';
}
