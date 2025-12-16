// lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'home/home_page.dart';
import 'profile/profile_page.dart';
import 'schedule/schedule_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index 0 = Home (Kiri)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Deklarasi List Halaman di dalam Build method
    final List<Widget> pages = [
      HomePage(onNavigate: _onItemTapped), // Index 0 - Home
      SchedulePage(onNavigate: _onItemTapped), // Index 1 - Schedule
      ProfilePage(), // Index 2 - Profile
    ];

    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          // Index 0 - Home
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // Index 1 - Schedule
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Schedule',
          ),
          // Index 2 - Profile
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
