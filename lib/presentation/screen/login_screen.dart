import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'Management/bottomNavigation_Screen.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  AuthService auth = AuthService();
  DatabaseHelper databaseHelper = DatabaseHelper();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
    } else {
      await auth.loginUser( email:email.text, password:password.text,context: context,);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomnavigationScreen()), // Ensure Signup is imported
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')));
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()), // Ensure Signup is imported
                );
              },
              child: const Text("Don't have an account? Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
