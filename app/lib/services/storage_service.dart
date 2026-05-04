import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();
  static const String _aKey = "a_tok"; //Access Token
  static const String _rKey = "r_tok"; //Refresh Token

  static Future<void> saveAccessKey(String token) async {
    await _storage.write(key: _aKey, value: token);
  }

  static Future<void> saveRefreshKey(String token) async {
    await _storage.write(key: _rKey, value: token);
  }

  static Future<String?> getAccessKey() async {
    return await _storage.read(key: _aKey);
  }

  static Future<String?> getRefreshKey() async {
    return await _storage.read(key: _rKey);
  }

}