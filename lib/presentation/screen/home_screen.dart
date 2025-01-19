import 'package:bachelor_meal_asistance/presentation/screen/Management/joinGroup.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/login_screen.dart';
import 'package:flutter/material.dart';
import '../uitils/Theme/theme.dart';
import 'Management/createGroup.dart';
import 'auth/databaseHelper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  TextEditingController meal = TextEditingController();
  DatabaseHelper databaseHelper = DatabaseHelper();
  AuthService authService = AuthService();
  var mealType = 0;

  void inputMeal() async {
    DateTime time = DateTime.now();
    int hour = time.hour;

    if (hour >= 20 && hour <= 6) {
      databaseHelper.addBreakfastMeal(meal: meal.text.trim());
    } else if (hour >= 21 && hour <= 8) {
      databaseHelper.addLunchMeal(meal: meal.text.trim());
    } else if (hour >= 13 && hour <= 18) {
      databaseHelper.addDinnerMeal(meal: meal.text.trim());
    }
    ;
  }

  void signOut() {
    authService.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text('Input Day Meal'),
              SizedBox(height: 10,),
              TextField(
                controller: meal,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Add Meal',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: inputMeal,
                child: Text(
                  'Submit',
                  style: textTheme.headlineSmall,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text('Update Day Meal'),
              SizedBox(height: 10,),
              Container(
                height: 200,
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Break First'),
                              SizedBox(
                                width: 5,
                              ),
                              Text(''),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Lunch'),
                              SizedBox(
                                width: 5,
                              ),
                              Text(''),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Dinner'),
                              SizedBox(
                                width: 5,
                              ),
                              Text(''),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text('To-Day Bazar Input'),
              SizedBox(height: 10,),
              TextField(
                controller: meal,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              TextField(
                controller: meal,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Price',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: inputMeal,
                child: Text(
                  'Submit',
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
