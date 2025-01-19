import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:bachelor_meal_asistance/presentation/screen/home_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'Profile_screen.dart';

class BottomnavigationScreen extends StatefulWidget {
  const BottomnavigationScreen({super.key});

  @override
  State<BottomnavigationScreen> createState() => _BottomnavigationScreenState();
}

class _BottomnavigationScreenState extends State<BottomnavigationScreen> {
  TextEditingController meal = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  AuthService authService = AuthService();
  var mealType = 0;

  // Meal input function
  void inputMeal() async {
    DateTime time = DateTime.now();
    int hour = time.hour;

    if (hour >= 6 && hour < 12) {
      databaseHelper.addBreakfastMeal(meal: meal.text.trim());
    } else if (hour >= 12 && hour < 17) {
      databaseHelper.addLunchMeal(meal: meal.text.trim());
    } else if (hour >= 17 && hour < 21) {
      databaseHelper.addDinnerMeal(meal: meal.text.trim());
    }
  }

  // SignOut function
  void signOut() {
    authService.signOut(context);
  }

  int _selectedIndex = 0;

  // Pages for BottomNavigationBar
  final List<Widget> _pages = [
    HomeScreen(),
    Login(),
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
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
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
