import '../models/treatment_model.dart';
import 'supabase_client.dart';

class TreatmentService {
  /// Ambil data treatment dari tabel "treatments" di Supabase
  Future<Map<String, List<Treatment>>> getTreatmentData() async {
    try {
      final response = await SupabaseManager.client
          .from('treatments')
          .select()
          .order('category', ascending: true);

      if (response.isNotEmpty) {
        final Map<String, List<Treatment>> grouped = {};

        for (var item in response) {
          final category = item['category'] ?? 'Uncategorized';
          final treatment = Treatment(
            name: item['name'] ?? 'Unknown',
            price: item['price'] ?? 0,
          );

          grouped.putIfAbsent(category, () => []).add(treatment);
        }

        print(
            '✅ Data treatments fetched successfully (${response.length} items)');
        return grouped;
      } else {
        print(
            '⚠️ No data found in treatments table, using static data fallback.');
        return _getStaticData();
      }
    } catch (e) {
      print('⚠️ Error fetching treatments: $e');
      return _getStaticData(); // fallback ke data statis
    }
  }

  /// Data statis fallback (jika Supabase gagal)
  Map<String, List<Treatment>> _getStaticData() {
    return {
      "Basic Care": [
        Treatment(name: "Hair Wash", price: 25000),
        Treatment(name: "Hair Wash + Blow", price: 40000),
        Treatment(name: "Hair Blow", price: 20000),
        Treatment(name: "Hair Cut", price: 50000),
      ],
      "Moisturizing": [
        Treatment(name: "Hair Spa", price: 45000),
        Treatment(name: "Creambath", price: 35000),
        Treatment(name: "Hair Mask", price: 40000),
      ],
      "Scalp Care": [
        Treatment(name: "Scalp Detox", price: 50000),
        Treatment(name: "Anti Dandruff", price: 45000),
      ],
      "Coloring": [
        Treatment(name: "Full Colour", price: 80000),
        Treatment(name: "Highlight", price: 100000),
        Treatment(name: "Balayage", price: 120000),
      ],
    };
  }
}
