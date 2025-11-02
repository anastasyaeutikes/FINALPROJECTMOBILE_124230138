import 'package:flutter/material.dart';
import '../models/treatment_model.dart';
import 'home_page.dart';
import 'treatment_page.dart';
import 'contactus_page.dart';
import 'profile_page.dart';
import 'set_appoinment_page.dart'; // ✅ Tambahkan import halaman tujuan

class TreatmentDetailPage extends StatefulWidget {
  final String title;
  final String imagePath;
  final List<Treatment> treatments;

  const TreatmentDetailPage({
    super.key,
    required this.title,
    required this.imagePath,
    required this.treatments,
  });

  @override
  State<TreatmentDetailPage> createState() => _TreatmentDetailPageState();
}

class _TreatmentDetailPageState extends State<TreatmentDetailPage> {
  List<Treatment> get selected =>
      widget.treatments.where((t) => t.isSelected).toList();

  void toggleTreatment(Treatment t, bool add) {
    setState(() => t.isSelected = add);
  }

  int get totalPrice => selected.fold(0, (sum, item) => sum + item.price);

  String _formatCurrency(int number) {
    final s = number.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),
      body: Column(
        children: [
          // ===== HEADER =====
          Stack(
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(0, 1),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ===== DAFTAR TREATMENT =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.treatments.map((t) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatCurrency(t.price),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ]),
                          Row(children: [
                            if (t.isSelected)
                              GestureDetector(
                                onTap: () => toggleTreatment(t, false),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  margin: const EdgeInsets.only(right: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF9E9DD),
                                    border: Border.all(
                                        color: const Color(0xFFD1A07C)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.remove,
                                      size: 18, color: Color(0xFFD1A07C)),
                                ),
                              ),
                            GestureDetector(
                              onTap: () => toggleTreatment(t, true),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9E9DD),
                                  border: Border.all(
                                      color: const Color(0xFFD1A07C)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.add,
                                    size: 18, color: Color(0xFFD1A07C)),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    );
                  }),
                  if (selected.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      "Treatment Details",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: selected
                          .map((t) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(t.name,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins')),
                                    Text(_formatCurrency(t.price),
                                        style: const TextStyle(
                                            fontFamily: 'Poppins')),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Price",
                                  style: TextStyle(fontFamily: 'Poppins')),
                              Text(_formatCurrency(totalPrice),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold)),
                            ]),
                        ElevatedButton(
                          // ✅ Tambahkan navigasi ke SetAppointmentPage
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SetAppoinmentPage(
                                  selectedTreatments: selected,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD1A07C),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Set Appointment",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),

      // ===== NAVIGATION BAR =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const TreatmentPage()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.article_outlined,
                    color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsPage()),
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFFC88E63),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
