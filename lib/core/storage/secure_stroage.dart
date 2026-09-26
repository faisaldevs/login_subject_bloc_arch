import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login_subject_demo_bloc_arch/core/error/exceptions.dart';
import 'package:login_subject_demo_bloc_arch/core/storage/base_secure_storage.dart';

class SecureStroage implements BaseSecureStorage {
  const SecureStroage(this._storage);

  static const _accessTokenKey = "acess_token_key";
  static const _refreshTokenKey = "refresh_token_key";

  final FlutterSecureStorage _storage;

  @override
  Future<void> clearToken() async {
    try {
      await Future.wait([
        _storage.delete(key: _accessTokenKey),
        _storage.delete(key: _refreshTokenKey),
      ]);
    } catch (e) {
      throw CacheException(message: "Could not clear tokens: ${e.toString()}");
    }
  }

  @override
  Future<String?> getAcessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      throw CacheException(
        message: "Could not read access token: ${e.toString()}",
      );
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      throw CacheException(
        message: "Could not read refresh token: ${e.toString()}",
      );
    }
  }

  @override
  Future<void> saveToken({
    required String acessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        _storage.write(key: _accessTokenKey, value: acessToken),
        _storage.write(key: _refreshTokenKey, value: refreshToken),
      ]);
    } catch (e) {
      throw CacheException(message: "Could not save tokens: ${e.toString()}");
    }
  }
}
