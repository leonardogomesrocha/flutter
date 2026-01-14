class AuthSession {
  // Singleton instance
  static final AuthSession _instance = AuthSession._internal();

  factory AuthSession() => _instance;

  AuthSession._internal();

  // ========================
  // Auth data
  // ========================
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  DateTime? expiresAt;

  // ========================
  // Session management
  // ========================

  void setSession({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
  }) {
    this.accessToken = accessToken;
    this.tokenType = tokenType;
    this.expiresIn = expiresIn;
    expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
  }

  /// ✅ Explicit check before requests
  bool hasValidToken() {
    if (accessToken == null || expiresAt == null) return false;
    return DateTime.now().isBefore(expiresAt!);
  }

  /// Optional: keep for UI logic
  bool get isLoggedIn => hasValidToken();

  /// Authorization header helper
  String? get authorizationHeader {
    if (!hasValidToken()) return null;
    return '$tokenType $accessToken';
  }

  /// Time remaining (useful for debugging / refresh logic)
  Duration? get timeUntilExpiration {
    if (expiresAt == null) return null;
    return expiresAt!.difference(DateTime.now());
  }

  void clear() {
    accessToken = null;
    tokenType = null;
    expiresIn = null;
    expiresAt = null;
  }
}
