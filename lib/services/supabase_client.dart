import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseManager {
  static SupabaseClient? _client;

  static Future<void> init() async {
    if (_client != null) return;

    try {
      await Supabase.initialize(
        url: 'https://osmqwqpkpcfjqvoqxnit.supabase.co',
        anonKey: 'sb_publishable_-B-1U8aVmBaH4q7Iu-2D3w_XcM8Fx5p',
      );
      _client = Supabase.instance.client;
      print('Supabase initialized successfully'); // Debug log
    } catch (e) {
      print('Supabase initialization error: $e'); // Debug log
      rethrow;
    }
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase client not initialized. Call init() first.');
    }
    return _client!;
  }
}
