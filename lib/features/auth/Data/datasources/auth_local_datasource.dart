import 'dart:convert';

import 'package:batch35_floorease/features/auth/data/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:bcrypt/bcrypt.dart';

class AuthLocalDatasource {
  static const _boxName = 'users';
  static const _storageKey = 'hive_encryption_key';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Box<User>? _box;

  Future<Box<User>> _openBox() async {
    if (_box != null && _box!.isOpen) return _box!;

    final existingKey = await _secureStorage.read(key: _storageKey);
    List<int> key;
    if (existingKey == null) {
      key = Hive.generateSecureKey();
      await _secureStorage.write(key: _storageKey, value: base64Encode(key));
    } else {
      key = base64Decode(existingKey);
    }

    final cipher = HiveAesCipher(key);
    _box = await Hive.openBox<User>(_boxName, encryptionCipher: cipher);
    return _box!;
  }

  Future<bool> register(String name, String email, String password) async {
    final box = await _openBox();
    final normalizedEmail = email.trim().toLowerCase();
    final exists = box.values.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );
    if (exists) return false;

    final passwordHash = BCrypt.hashpw(password, BCrypt.gensalt());

    final user = User(
      name: name,
      email: normalizedEmail,
      password: passwordHash,
    );
    await box.put(normalizedEmail, user);
    return true;
  }

  Future<User?> login(String email, String password) async {
    final box = await _openBox();
    final normalizedEmail = email.trim().toLowerCase();
    try {
      User? user = box.get(normalizedEmail);
      if (user == null) {
        for (final u in box.values) {
          if (u.email.toLowerCase() == normalizedEmail) {
            user = u;
            break;
          }
        }
      }
      if (user == null) return null;
      final ok = BCrypt.checkpw(password, user.password);
      if (ok) return user;
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<List<User>> getAllUsers() async {
    final box = await _openBox();
    return box.values.toList();
  }
}
