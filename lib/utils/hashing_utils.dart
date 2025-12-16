// lib/utils/hashing_utils.dart

import 'dart:convert';
import 'package:crypto/crypto.dart';

// Fungsi placeholder untuk hashing (menggunakan SHA256)
String hashPassword(String password) {
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  return hash.toString();
}
