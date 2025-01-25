import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../auth/auth_screen.dart';
import '../auth/databaseHelper.dart';

class GroupDashboardScreen extends StatefulWidget {

  const GroupDashboardScreen({super.key,});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  TextEditingController mealController = TextEditingController();
  TextEditingController bazaarItem = TextEditingController();
  TextEditingController bazaarPrice = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  AuthService authService = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;

  String selectMealType = '';
  String? groupName;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime toDay = DateTime.now();
  DateTime nextDay = DateTime.now().add(Duration(days: 1));
  DateTime startDay = DateTime.utc(2000, 1, 1);
  DateTime endDay = DateTime.utc(2100, 12, 31);
  DateTime? _selectedDay;
  Set<DateTime> selectedDays = {};
  DateTime? _focusedDay;

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getGroupName() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(auth.currentUser!.uid)
        .child('groups');

    userRef.once().then((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final List<dynamic> data = event.snapshot.value as List<dynamic>;
        setState(() {
          groupName = data.isNotEmpty ? data.last.toString() : 'No Group';
        });
      } else {
        setState(() {
          groupName = 'No Group';
        });
      }
    });
  }

  void initState() {
    super.initState();
    _focusedDay;
    _selectedDay;
    getGroupName();
    bazaarPrice.text.trim();
    bazaarItem.text.trim();
  }

  void inputMeal() async {
    if (groupName == null || groupName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name not found!')),
      );
      return;
    }

    if (selectMealType.isEmpty || mealController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a meal type and enter a value')),
      );
      return;
    }
    if (selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a Day')),
      );
      return;
    }

    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('groups').child(groupName!);

    Map<String, dynamic> mealData = {
      'time': '$selectedDays',
      'meal': mealController.text,
    };

    try {
      String month = DateFormat.MMMM().format(DateTime.now()); // Add month in the format MM
      if (selectMealType == 'breakfast') {
        await databaseReference
            .child('breakfast')
            .child(auth.currentUser!.uid)
            .child(month)
            .push()
            .set(mealData);
      } else if (selectMealType == 'lunch') {
        await databaseReference
            .child('lunch')
            .child(auth.currentUser!.uid)
            .child(month)
            .push()
            .set(mealData);
      } else if (selectMealType == 'dinner') {
        await databaseReference
            .child('dinner')
            .child(auth.currentUser!.uid)
            .child(month)
            .push()
            .set(mealData);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal input successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> inputBazaarItem()async
  {

    if (groupName == null || groupName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Group name not found!')),
      );
      return;
    }

    if (bazaarItem.text.isEmpty || bazaarPrice.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Please select $bazaarItem or $bazaarPrice type and enter a value')),
      );
      return;
    }
    Map <String,dynamic> bazarData={
      'bazaarItem': bazaarItem,
      'bazaarPrice':bazaarPrice,
      'time': DateTime.now().toIso8601String(),
    };
    String month = DateFormat.MMMM().format(DateTime.now());
    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('groups').child(groupName!);
    await databaseReference
        .child('bazaar')
        .child(auth.currentUser!.uid)
        .child(month)
        .push()
        .set(bazarData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your  input successful!')),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(groupName?? 'Loading...', style: textTheme.headlineMedium)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Input Day Meal', style: textTheme.headlineSmall),
              const SizedBox(height: 10),
              TextField(
                controller: mealController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Add Meal',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => selectMealType = 'breakfast'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectMealType == 'breakfast'
                          ? Colors.green
                          : Colors.blue,
                    ),
                    child: const Text('Breakfast'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => selectMealType = 'lunch'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectMealType == 'lunch'
                          ? Colors.green
                          : Colors.blue,
                    ),
                    child: const Text('Lunch'),
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() => selectMealType = 'dinner'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectMealType == 'dinner'
                          ? Colors.green
                          : Colors.blue,
                    ),
                    child: const Text('Dinner'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 340,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.lightGreen, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TableCalendar(
                      focusedDay: toDay,
                      firstDay: startDay,
                      lastDay: endDay,
                      rowHeight: 45,
                      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                      selectedDayPredicate: (day) {
                        return selectedDays.contains(day); // Check if the day is selected
                      },
                      enabledDayPredicate: (day) {
                        return isSameDate(day, toDay) || isSameDate(day, nextDay); // Allow only today or next day
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          if (isSameDate(focusedDay, toDay) || isSameDate(focusedDay, nextDay)) {
                            selectedDays.clear();
                            selectedDays.add(focusedDay); // Add the newly selected day
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          }
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      calendarStyle: CalendarStyle(
                        selectedDecoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),

                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50)
                ),
                onPressed: inputMeal,
                child: const Text('Submit'),
              ),
              const SizedBox(height: 30),
              Text('Bazaar Item', style: textTheme.headlineSmall),
              const SizedBox(height: 10),
              TextField(
                controller: bazaarItem,
                decoration: const InputDecoration(
                  labelText: 'Add bazaar Item',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 10),
              Text('Input Bazaar Price', style: textTheme.headlineSmall),
              const SizedBox(height: 10),
              TextField(
                controller: bazaarPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Add Price',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(200, 50)
                ),
                onPressed: inputBazaarItem ,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
