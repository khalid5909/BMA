import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Management/Profile_screen.dart';


class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase dbRef = FirebaseDatabase.instance;
  final DatabaseHelper databaseHelper =DatabaseHelper();
  UserDatabase userDatabase = UserDatabase();

  Future signUp(
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
          'createdAt': DateTime.now().toIso8601String(),
        };
        userRef.set(userData);
      }
      return singUpUser;
    } catch (e)
    {
      print("Error during sign-up: $e");
    }
  }

  Future<User?> loginUser( {required String email,required String password,required BuildContext context}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String? currentUserEmail = auth.currentUser?.email;
      Navigator.push(
        context,
        MaterialPageRoute(builder:
            (context) => const ProfileScreen(),
        ),
      );
      //databaseHelper.checkMemberAndRedirect(currentUserEmail: currentUserEmail as String ,context: context);
      return userCredential.user;

    } catch (e) {
      return null;
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
