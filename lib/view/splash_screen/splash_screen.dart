import 'package:flutter/material.dart';
import 'package:news_app/view/signup_screen/login_in_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 3),() => Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen(),
        )
        ),
        );
    return Scaffold(
      body: Center(
        child: Text("News App",style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }
}