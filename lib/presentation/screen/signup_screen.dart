
import 'package:flutter/material.dart';
import 'auth/auth_screen.dart';
import 'login_screen.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final AuthService auth = AuthService();
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  Future<void> signUp() async {
    try{
      if(email.text.isEmpty || password.text.isEmpty || name.text.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
      }else {
        await auth.signUp(email: email.text, password: password.text, name: name.text, );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
            }
    }catch(e)
    {
      ();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Text("Signup", style: textTheme.headlineMedium),
              const Text("Welcome!", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 40),
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Username'),
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                style: textTheme.headlineSmall,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: password,
                decoration: const InputDecoration(labelText: 'Password'),
                style: textTheme.headlineSmall,
                obscureText: true,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: signUp,
                  child: Text("Signup", style: textTheme.headlineSmall),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google signup
                  },
                  icon: Image.asset(
                    'assets/logo/googleicon.png',
                    width: 24,
                    height: 24,
                  ),
                  label: Text("Signup with Google",
                      style: textTheme.headlineSmall),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: textTheme.bodySmall),
                  TextButton(
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login())),
                    child: const Text("Login"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
