import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:postgrest/postgrest.dart';
import 'supabase_client.dart';
import 'encryption_service.dart';

class AuthService {
  final _supabase = SupabaseManager.client;

  Future<Map<String, dynamic>> signUp(
      String name, String username, String email, String password) async {
    try {
      // Hash password locally
      final hashedPassword = EncryptionService.encryptPassword(password);

      // Create auth user (supabase auth)
      final res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'username': username},
      );

      if (res.user == null) {
        return {'success': false, 'error': 'Signup failed (no user returned).'};
      }

      final userId = res.user!.id;

      // Try to insert profile with password_hash (may fail due to RLS)
      try {
        await _supabase.from('profiles').insert({
          'id': userId,
          'name': name,
          'username': username,
          'email': email,
          'password_hash': hashedPassword,
          'created_at': DateTime.now().toIso8601String(),
        }).execute();

        return {
          'success': true,
          'userId': userId,
          'profileCreated': true,
        };
      } on PostgrestException catch (e) {
        // Likely RLS prevented the insert — return success for auth user but warn profile not created
        return {
          'success': true,
          'userId': userId,
          'profileCreated': false,
          'warning': 'profile_insert_failed',
          'error': e.message,
        };
      } catch (e) {
        return {
          'success': true,
          'userId': userId,
          'profileCreated': false,
          'error': e.toString(),
        };
      }
    } on AuthException catch (e) {
      return {'success': false, 'error': e.message};
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      // Get user profile including password_hash
      final user = await _supabase
          .from('profiles')
          .select('id, name, username, email, password_hash')
          .eq('email', email)
          .maybeSingle();

      if (user == null) {
        return {'success': false, 'error': 'User not found'};
      }

      final storedHash = user['password_hash'] as String?;
      if (storedHash == null ||
          !EncryptionService.verifyPassword(password, storedHash)) {
        return {'success': false, 'error': 'Invalid password'};
      }

      // Update last login timestamp
      try {
        await _supabase
            .from('profiles')
            .update({
              'last_login': DateTime.now().toIso8601String(),
            })
            .eq('id', user['id'])
            .execute();
      } catch (_) {
        // ignore update failures (RLS) but proceed with successful login
      }

      return {
        'success': true,
        'name': user['name'],
        'username': user['username'],
        'email': user['email'],
        'userId': user['id'],
      };
    } catch (e) {
      print('SignIn error: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      print('SignOut error: $e');
    }
  }
}
