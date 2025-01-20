import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:bachelor_meal_asistance/presentation/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase dbRef = FirebaseDatabase.instance;
  final DatabaseHelper databaseHelper =DatabaseHelper();
  UserDatabase userDatabase = UserDatabase();
  String groupName= 'No Data';

  Future <void> signUp(
      {required String email,
      required String password,
      required String name,
      }) async {
    try {
      final User?  singUpUser = (await auth.createUserWithEmailAndPassword(
          email: email, password: password)).user;
      if (singUpUser != null) {
        DatabaseReference userRef = dbRef.ref().child('user').child(singUpUser.uid);
        Map<String, dynamic> userData = {
          'userId': singUpUser.uid,
          'name': name,
          'email': email,
          'phone':'',
          'groups': [groupName],
          'createdAt': DateTime.now().toIso8601String(),
        };
        userRef.set(userData);
      }
    } catch (e)
    {
      print("Error during sign-up: $e");
    }
  }

  Future<void> loginUser ({required String email,required String password,required BuildContext context}) async {
    try {
      final User?  loginUser = (await auth.signInWithEmailAndPassword(
          email: email, password: password)).user ;
      if(loginUser!= null)
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder:
                (context) => const HomeScreen(),
            ),
          );
        }else
      {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Failed')));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not Found')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong Password')));
      }else if(e.code == 'invalid-email'){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Email')));
      }
    }
  }




  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
      _showSnackBar(context, "Successfully signed out");
    } catch (e) {
      _showSnackBar(context, "Sign out failed: ${_handleError(e)}");
    }
  }

  String _handleError(Object error) {
    if (error is FirebaseAuthException) {
      return error.message ?? 'An unknown error occurred';
    }
    return error.toString();
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }


}
