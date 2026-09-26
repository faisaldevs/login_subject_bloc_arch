abstract class BaseSecureStorage {
  Future<void> saveToken({
    required String acessToken,
    required String refreshToken,
  });

  Future<String?> getAcessToken();
  Future<String?> getRefreshToken();
  Future<void> clearToken();
}
