import 'dart:convert';
import 'package:crypto/crypto.dart';

class EncryptionService {
  static String encryptPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final hash = sha256.convert(bytes); // Create SHA256 hash
    return hash.toString(); // Return encrypted string
  }

  static bool verifyPassword(String password, String hashedPassword) {
    final hashedInput = encryptPassword(password);
    return hashedInput == hashedPassword;
  }
}
