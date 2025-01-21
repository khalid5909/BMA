import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Management/Dashboard_screan.dart';
import 'signup_screen.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();



  signIn()async{
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
    Navigator.push(
      context,
      MaterialPageRoute(builder:
          (context) => const DashboardScrean(),
      ),
    );
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
              onPressed: (()=> signIn) ,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: (() => Signup),
              child: const Text("Don't have an account? Signup"),
            ),
          ],
        ),
      ),
    );
  }
}
