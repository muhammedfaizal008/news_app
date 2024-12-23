import 'package:flutter/material.dart';

class BottomNavbarScreenController with ChangeNotifier{
  int currentIndex=0;
  changeScreen(int value){
    currentIndex=value;
    notifyListeners();
  }

}