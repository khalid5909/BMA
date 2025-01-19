import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:bachelor_meal_asistance/presentation/uitils/Theme/button_theme_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'createGroup.dart';
import 'joinGroup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;
  AuthService authService = AuthService();
  DatabaseHelper databaseHelper = DatabaseHelper();
  UserDatabase userDatabase = UserDatabase();


  void getNameRealTime() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(auth.currentUser!.uid).child('name');

    DataSnapshot snapshot = await userRef.get();
    if(snapshot.exists){
      snapshot.value;
    }else{
      snapshot.value == null;
    }
  }

  void getMail()async
  {
    await userDatabase.getMail();
  }







  void signOut (){
    authService.signOut(context);
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile',style: textTheme.headlineMedium,) ,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: Colors.lightGreen, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text('$getNameRealTime',
              style: textTheme.headlineLarge,),
              SizedBox(height: 10,),
              Text('$getMail',
              style: textTheme.headlineMedium,),
              SizedBox(height: 40,),
              Container(
                height: 320,
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
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateGroup()));
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(400, 60)
                        ),
                        child: Text(
                          'Member',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> JoinGroupPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 60)
                        ),
                        child: Text(
                          'Create Group',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> JoinGroupPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 60)
                        ),
                        child: Text(
                          'Join Group',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> JoinGroupPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 60)
                        ),
                        child: Text(
                          'Notice',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> JoinGroupPage()));
                        },
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(400, 60)
                        ),
                        child: Text(
                          'Sign Out',
                          style: textTheme.headlineSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
