import 'package:bachelor_meal_asistance/presentation/screen/Management/joinGroup.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  FirebaseAuth auth =FirebaseAuth.instance;
  var mealType = 0;
  List<String> allGroupName=[];

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

  void getGroupName() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(auth.currentUser!.uid).child('groups');
    userRef.onValue.listen((DatabaseEvent event){
      if (event.snapshot.exists) {
        final List<dynamic>? groupList = event.snapshot.value as List<dynamic>?;
        if(groupList!= null){
          setState(() {
            allGroupName = groupList.cast<String>();
          });
        } else {
          setState(() {
            allGroupName = [];
          });
        }

      } else {
        setState(() {
          allGroupName = "Name not found!" as List<String>;
        });
      }

    });
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
          child: Container(
            child: ListView.builder(
                itemCount: allGroupName.length,
                itemBuilder: (BuildContext context,int index){
                  return Card(
                      child: ListTile(
                        title: Text(allGroupName[index],style: textTheme.headlineSmall),
                        leading: CircleAvatar(
                          child: Text(allGroupName[index][0],style: textTheme.headlineSmall),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
                        },
                      )
                  );
                }),
          )
        ),
      ),
    );
  }
}
