import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QRepo {
  static const urlCode = 'urlCode';
  final _storage = FlutterSecureStorage();

  Future<String> getUrlCode() => _storage.read(key: urlCode);
  Future<void> setUrlCode(String url) => _storage.write(key: urlCode, value: url);
  Future<void> removeUrlCode() => _storage.delete(key: urlCode);
}
