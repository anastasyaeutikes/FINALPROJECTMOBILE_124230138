import 'package:flutter/material.dart';
import '../services/treatment_service.dart';
import '../models/treatment_model.dart';
import 'treatment_detail_page.dart';
import 'home_page.dart';
import 'contactus_page.dart';
import 'profile_page.dart';

class TreatmentPage extends StatefulWidget {
  const TreatmentPage({super.key});

  @override
  State<TreatmentPage> createState() => _TreatmentPageState();
}

class _TreatmentPageState extends State<TreatmentPage> {
  late Future<Map<String, List<Treatment>>> treatmentsFuture;

  @override
  void initState() {
    super.initState();
    treatmentsFuture = TreatmentService().getTreatmentData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),

      // ===== BODY UTAMA =====
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Judul di tengah
              Center(
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: "Hayyina’s ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "Treatment",
                        style: TextStyle(color: Color(0xFFC88E63)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black26),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search treatment...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // FutureBuilder untuk menunggu data treatments
              Expanded(
                child: FutureBuilder<Map<String, List<Treatment>>>(
                  future: treatmentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFC88E63),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load treatments',
                          style: const TextStyle(fontFamily: 'Poppins'),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text(
                          'No treatment data available.',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                      );
                    }

                    final treatments = snapshot.data!;
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 0.65,
                      children: treatments.keys.map((category) {
                        final imagePath =
                            'lib/assets/${category.toLowerCase().replaceAll(" ", "")}.png';
                        final categoryTreatments = treatments[category]!;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TreatmentDetailPage(
                                  title: category,
                                  treatments: categoryTreatments,
                                  imagePath: imagePath,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Gambar
                                Expanded(
                                  flex: 8,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                ),

                                // Area coklat untuk teks
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 6),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFC88E63),
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    category,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== NAVIGATION BAR =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 14, left: 24, right: 24),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
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
              // HOME
              IconButton(
                icon: const Icon(Icons.home, color: Colors.black, size: 24),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
              ),

              // SEARCH
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 24),
                onPressed: () {},
              ),

              // CONTACT US
              IconButton(
                icon: const Icon(Icons.article_outlined,
                    color: Colors.black, size: 24),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsPage()),
                  );
                },
              ),

              // PROFILE
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  );
                },
                child: const CircleAvatar(
                  radius: 9,
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
