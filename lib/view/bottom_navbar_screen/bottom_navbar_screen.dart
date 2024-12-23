import 'package:flutter/material.dart';
import 'package:news_app/controller/bottom_navbar_screen_controller.dart';
import 'package:news_app/view/home_screen/home_screen.dart';
import 'package:news_app/view/profile_screen/profile_screen.dart';
import 'package:news_app/view/search_screen/search_screen.dart';
import 'package:provider/provider.dart';

class BottomNavbarScreen extends StatelessWidget {
  const BottomNavbarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BottomNavbarScreenController x = context.watch<BottomNavbarScreenController>();
    List screens = [
      HomeScreen(),
      SearchScreen(),
      ProfileScreen()
    ];
    return Scaffold(
      body: screens[x.currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8,right: 8,left: 8),
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 10,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: x.currentIndex,
          selectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600
          ),
          onTap: (value) {
            context.read<BottomNavbarScreenController>().changeScreen(value);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.black),
              label: "Home",
              activeIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.home_filled, color: Colors.black),
                  const SizedBox(width: 8.0),
                  Text("Home", style: TextStyle(color: Colors.black))
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined, color: Colors.black),
              label: "Search",
              activeIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search, color: Colors.black),
                  const SizedBox(width: 8.0),
                  Text("Search", style: TextStyle(color: Colors.black))
                ],
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: Colors.black),
              label: "Profile",
              activeIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, color: Colors.black),
                  const SizedBox(width: 8.0),
                  Text("Profile", style: TextStyle(color: Colors.black))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
