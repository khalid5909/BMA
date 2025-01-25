import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return false;
        },

    child:  Scaffold(
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
    ),
    );
  }
}
