import 'package:bachelor_meal_asistance/presentation/screen/splash_screen.dart';
import 'package:bachelor_meal_asistance/presentation/uitils/Theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BechelorMealAsistance());

}

class BechelorMealAsistance extends StatefulWidget {
  const BechelorMealAsistance({super.key});

  @override
  State<BechelorMealAsistance> createState() => _BechelorMealAsistanceState();
}

class _BechelorMealAsistanceState extends State<BechelorMealAsistance> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.darktheme,
      themeMode: ThemeMode.system,
      home: const Splash(),
    );
  }
}
