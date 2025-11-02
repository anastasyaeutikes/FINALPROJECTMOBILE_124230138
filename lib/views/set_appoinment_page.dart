import 'package:flutter/material.dart';
import 'payment_page.dart';
import '../models/treatment_model.dart';
import 'home_page.dart';
import 'treatment_page.dart';
import 'contactus_page.dart';
import 'profile_page.dart';

class SetAppoinmentPage extends StatefulWidget {
  final List<Treatment> selectedTreatments;

  const SetAppoinmentPage({
    super.key,
    required this.selectedTreatments,
  });

  @override
  State<SetAppoinmentPage> createState() => _SetAppoinmentPageState();
}

class _SetAppoinmentPageState extends State<SetAppoinmentPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  String selectedZone = 'WIB';
  String? convertedTime;

  final List<String> availableTimes = [
    '10:00 AM',
    '11:00 AM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
  ];

  final List<String> timeZones = [
    'WIB',
    'WITA',
    'WIT',
    'London',
    'Tokyo',
    'New York',
    'Sydney',
    'Dubai',
  ];

  // Offset per zona waktu terhadap WIB
  final Map<String, int> timeOffset = {
    'WIB': 0,
    'WITA': 1,
    'WIT': 2,
    'London': -7,
    'Tokyo': 8,
    'New York': -12,
    'Sydney': 9,
    'Dubai': -3,
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  String _formatCurrency(int number) {
    final s = number.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  void _convertTime() {
    if (selectedTime == null) {
      setState(() => convertedTime = null);
      return;
    }

    try {
      final timeParts = selectedTime!.split(' ');
      final hourMinute = timeParts[0].split(':');
      int hour = int.parse(hourMinute[0]);
      final minute = int.parse(hourMinute[1]);
      final period = timeParts[1];

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      final baseTime = DateTime(2024, 1, 1, hour, minute);
      final offsetHour = timeOffset[selectedZone] ?? 0;
      final converted = baseTime.add(Duration(hours: offsetHour));

      final convertedFormatted =
          "${converted.hour.toString().padLeft(2, '0')}:${converted.minute.toString().padLeft(2, '0')} ($selectedZone)";

      setState(() => convertedTime = convertedFormatted);
    } catch (e) {
      setState(() => convertedTime = "Conversion error");
    }
  }

  // 🔹 Hitung total harga treatment
  int get totalPrice {
    return widget.selectedTreatments.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ======= TOP NAVIGATION (1 - 2) =======
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD1A07C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('1',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('2',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      // 🔹 Navigasi ke PaymentPage + kirim data treatment dan total price
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(
                            selectedTreatments: widget.selectedTreatments,
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios,
                        size: 20, color: Colors.black),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ======= DATE PICKER =======
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1), blurRadius: 4)
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ======= SELECTED TREATMENT =======
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Selected Treatment",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 4)
                  ],
                ),
                child: Column(
                  children: [
                    ...widget.selectedTreatments.map((t) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(t.name,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 13)),
                            Text(_formatCurrency(t.price),
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: Colors.grey)),
                          ],
                        ),
                      );
                    }),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _formatCurrency(totalPrice),
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD1A07C)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ======= AVAILABLE TIME =======
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Available Time",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: availableTimes.map((time) {
                  final isSelected = selectedTime == time;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                      _convertTime();
                    },
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFD1A07C) : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0xFFD1A07C), width: 1),
                      ),
                      child: Center(
                        child: Text(
                          time,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              if (convertedTime != null) ...[
                const SizedBox(height: 10),
                Text(
                  "Converted Time: $convertedTime",
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87),
                ),
              ],

              const SizedBox(height: 20),

              // ======= TIME CONVERSION =======
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Time Conversion?",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedZone,
                items: timeZones
                    .map((zone) => DropdownMenuItem(
                          value: zone,
                          child: Text(zone,
                              style: const TextStyle(fontFamily: 'Poppins')),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedZone = value!;
                  });
                  _convertTime();
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== NAVIGATION BAR BAWAH =====
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
