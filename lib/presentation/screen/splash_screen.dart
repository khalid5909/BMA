import 'package:bachelor_meal_asistance/presentation/screen/Management/bottomNavigation_Screen.dart';
import 'package:bachelor_meal_asistance/presentation/screen/Management/wrapper.dart';
import 'package:bachelor_meal_asistance/presentation/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import '../uitils/image_asset.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    goToNextScreen();
  }
  void goToNextScreen(){
    Future.delayed(const Duration(seconds: 3)).then((value){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
       const Wrapper()),(route)=>false);
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Container(
                height: 180,
                width: 180,
              child:  Image.asset(ImageAsset.BMAlogopng),
            ),
          ),
          Spacer(),
          CircularProgressIndicator(
            color: Color(0xFF81C784)
          ),
          SizedBox(height: 10,),
          Text("Version 1.0.0"),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
