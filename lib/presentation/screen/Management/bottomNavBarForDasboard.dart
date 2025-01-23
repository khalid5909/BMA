
import 'package:bachelor_meal_asistance/presentation/screen/Management/groupDashboard_screan.dart';
import 'package:bachelor_meal_asistance/presentation/screen/Management/member_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Profile_screen.dart';

class BotNavBarForDas extends StatefulWidget {
  const BotNavBarForDas({super.key});

  @override
  State<BotNavBarForDas> createState() => _BotNavBarForDasState();
}

class _BotNavBarForDasState extends State<BotNavBarForDas> {
  final user = FirebaseAuth.instance.currentUser;

  int _selectedIndex = 0;


  // Pages for BottomNavigationBar
  final List<Widget> _pages = [
    GroupDashboardScreen(groupName: '',),
    MemberScreen(),
    ProfileScreen(),
  ];

  // Change selected index
  void _itemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
        _selectedIndex, // Add currentIndex to reflect the selected index
        onTap: _itemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
