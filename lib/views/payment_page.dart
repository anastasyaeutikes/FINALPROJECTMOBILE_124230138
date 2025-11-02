import 'package:flutter/material.dart';
import '../models/treatment_model.dart';
import 'set_appoinment_page.dart';
import 'reservation_successful_page.dart';
import 'home_page.dart';
import 'treatment_page.dart';
import 'contactus_page.dart';
import 'profile_page.dart';

class PaymentPage extends StatefulWidget {
  final List<Treatment> selectedTreatments;
  final int totalPrice;

  const PaymentPage({
    super.key,
    this.selectedTreatments = const [],
    this.totalPrice = 0,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String selectedCurrency = 'IDR - Indonesian Rupiah';
  String selectedMethod = '';
  double exchangeRate = 1.0;

  final Map<String, double> currencyRates = {
    'IDR - Indonesian Rupiah': 1.0,
    'USD - US Dollar': 0.000064,
    'EUR - Euro': 0.000059,
    'JPY - Japanese Yen': 0.0096,
    'GBP - British Pound': 0.000051,
    'AUD - Australian Dollar': 0.000097,
    'SGD - Singapore Dollar': 0.000087,
    'CNY - Chinese Yuan': 0.00046,
  };

  String _formatCurrency(int number) {
    final s = number.toString();
    return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.');
  }

  double _convertCurrency(int amount) {
    return amount * exchangeRate;
  }

  @override
  Widget build(BuildContext context) {
    final convertedPrice = _convertCurrency(widget.totalPrice);
    final selected = widget.selectedTreatments;
    final totalPrice = widget.totalPrice;

    return Scaffold(
      backgroundColor: const Color(0xFFF9E9DD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === HEADER ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        size: 20, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SetAppoinmentPage(
                                  selectedTreatments: [],
                                )),
                      );
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('1',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Color(0xFFD1A07C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('2',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                ],
              ),

              const SizedBox(height: 20),

              // === TREATMENT DETAILS ===
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.1), blurRadius: 4)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selected.isNotEmpty) ...[
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
                            ],
                          ),
                        ],
                      ),
                    ] else
                      const Text(
                        "No treatment selected.",
                        style: TextStyle(
                            fontFamily: 'Poppins', color: Colors.grey),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // === CURRENCY CONVERSION ===
              const Text(
                "Currency Conversion",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCurrency,
                items: currencyRates.keys
                    .map((currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency,
                              style: const TextStyle(fontFamily: 'Poppins')),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCurrency = value!;
                    exchangeRate = currencyRates[selectedCurrency]!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${convertedPrice.toStringAsFixed(2)} ($selectedCurrency)",
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // === PAYMENT METHOD ===
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Payment Method",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text(
                      "Payment will be made after the treatment is completed",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPaymentOption("Cash", Icons.attach_money),
                        _buildPaymentOption("Q-ris", Icons.qr_code),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // === RESERVATION BUTTON ===
              Center(
                child: ElevatedButton(
                  onPressed: selectedMethod.isNotEmpty
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const ReservationSuccessfulPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1A07C),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 14),
                  ),
                  child: const Text(
                    "Reservation",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // === NAVBAR ===
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
                  offset: const Offset(0, 3))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const TreatmentPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.article_outlined,
                    color: Colors.black, size: 26),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ContactUsPage()));
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ProfilePage()));
                },
                child: const CircleAvatar(
                    radius: 10, backgroundColor: Color(0xFFC88E63)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // === Payment Option Widget ===
  Widget _buildPaymentOption(String label, IconData icon) {
    final isSelected = selectedMethod == label;
    return GestureDetector(
      onTap: () {
        setState(() => selectedMethod = label);
      },
      child: Container(
        width: 110,
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD1A07C) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD1A07C)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isSelected ? Colors.white : const Color(0xFFD1A07C),
                size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
