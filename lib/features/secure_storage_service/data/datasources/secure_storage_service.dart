import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<void> savePassword(String password);
  Future<String?> getPassword();
  Future<void> clearPassword();
  Future<void> saveUsername(String username);
  Future<String?> getUsername();
  Future<void> clearUsername();
  Future<void> clearAll();
  Future<bool> isLoggedIn();
}

class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _tokenKey = 'auth_token';
  static const _usernameKey = 'username';
  static const _passwordKey = 'password';

  @override
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  @override
  Future<void> savePassword(String password) async {
    await _storage.write(key: _passwordKey, value: password);
  }

  @override
  Future<String?> getPassword() async {
    return await _storage.read(key: _passwordKey);
  }

  @override
  Future<void> clearPassword() async {
    await _storage.delete(key: _passwordKey);
  }

  @override
  Future<void> saveUsername(String username) async {
    await _storage.write(key: _usernameKey, value: username);
  }

  @override
  Future<String?> getUsername() async {
    return await _storage.read(key: _usernameKey);
  }

  @override
  Future<void> clearUsername() async {
    await _storage.delete(key: _usernameKey);
  }

  @override
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
  
  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}