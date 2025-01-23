import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../auth/auth_screen.dart';
import '../auth/databaseHelper.dart';

class GroupDashboardScreen extends StatefulWidget {
  final String groupName;

  const GroupDashboardScreen({super.key, required this.groupName});

  @override
  State<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends State<GroupDashboardScreen> {
  TextEditingController mealController = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  AuthService authService = AuthService();
  FirebaseAuth auth = FirebaseAuth.instance;

  String selectMealType = '';
  String? groupName;
  DateTime nextDay = DateTime.now().add(Duration(days: 1));

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



  @override
  void initState() {
    super.initState();
    getGroupName();
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

    final DatabaseReference databaseReference =
    FirebaseDatabase.instance.ref().child('groups').child(groupName!);

    Map<String, dynamic> mealData = {
      'time': 'no',
      'meal': mealController.text,
    };

    try {
      String month = DateTime.now().month.toString().padLeft(2, '0');  // Add month in the format MM
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(groupName ?? 'Loading...', style: textTheme.headlineMedium),
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
              Container(height: 300,
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
                  child: SfCalendar(
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: inputMeal,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
