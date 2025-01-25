import 'package:bachelor_meal_asistance/presentation/screen/Management/bottomNavigationScreen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder <User?> (stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData){
          return BottomnavigationScreen();
        }else{
          return Login();
        }
      }),
    );
  }
}
