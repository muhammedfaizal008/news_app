// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:news_app/controller/bottom_navbar_screen_controller.dart';
import 'package:news_app/controller/home_screen_controller.dart';
import 'package:news_app/controller/individual_screen_controller.dart';
import 'package:news_app/controller/saved_screen_controller.dart';
import 'package:news_app/controller/search_screen_controller.dart';
import 'package:news_app/view/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await SavedScreenController.initDb();
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavbarScreenController(),),
        ChangeNotifierProvider(create: (context) => HomeScreenController(),),
        ChangeNotifierProvider(create: (context) => IndividualScreenController(),),
        ChangeNotifierProvider(create: (context) => SearchScreenController(),),
        ChangeNotifierProvider(create: (context) => SavedScreenController(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}