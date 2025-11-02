import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class PaymentService {
  final SupabaseClient _supabase = SupabaseManager.client;

  /// Buat catatan payment di tabel 'payments'
  /// Mengembalikan map dengan kunci 'success' dan 'data' atau 'error'
  Future<Map<String, dynamic>> createPayment({
    required String userId,
    required int amount, // dalam cents atau integer sesuai design DB
    String method = 'unknown',
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final insert = {
        'user_id': userId,
        'amount': amount,
        'method': method,
        'metadata': metadata,
      };

      final res = await _supabase
          .from('payments')
          .insert(insert)
          .select()
          .maybeSingle();

      return {'success': true, 'data': res};
    } catch (e, st) {
      // log error untuk debugging
      print('PaymentService.createPayment error: $e\n$st');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Ambil list payment user
  Future<Map<String, dynamic>> fetchPaymentsByUser(String userId) async {
    try {
      final res =
          await _supabase.from('payments').select('*').eq('user_id', userId);
      return {'success': true, 'data': res};
    } catch (e, st) {
      print('PaymentService.fetchPaymentsByUser error: $e\n$st');
      return {'success': false, 'error': e.toString()};
    }
  }

  /// Contoh refund (jika Anda hanya menandai di DB)
  Future<Map<String, dynamic>> markRefunded(String paymentId) async {
    try {
      final res = await _supabase
          .from('payments')
          .update({'status': 'refunded'})
          .eq('id', paymentId)
          .select()
          .maybeSingle();
      return {'success': true, 'data': res};
    } catch (e, st) {
      print('PaymentService.markRefunded error: $e\n$st');
      return {'success': false, 'error': e.toString()};
    }
  }
}
