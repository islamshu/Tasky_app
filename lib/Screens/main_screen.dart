import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/Screens/complete_screen.dart';
import 'package:flutter_projects/Screens/home_screen.dart';
import 'package:flutter_projects/Screens/profile_screen.dart';
import 'package:flutter_projects/Screens/tasks_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget screen = HomeScreen();
  List<Widget> _screen = [
    HomeScreen(),
    TasksScreen(),
    CompleteScreen(),
    ProfileScreen(),
  ];
  int _curentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _curentIndex,
        onTap: (int? index) {
          setState(() {
            _curentIndex = index ?? 0;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon:  _buildSvgPicture("assets/images/home.svg",0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture( "assets/images/todo.svg",1),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture( "assets/images/complete.svg",2),
            label: "Complete",
          ),
          BottomNavigationBarItem(
            icon: _buildSvgPicture( "assets/images/profile.svg",3),

            label: "Profile",
          ),
        ],
      ),
      body: SafeArea(child: _screen[_curentIndex]),
    );
  }

  SvgPicture _buildSvgPicture(String path,int index) {
    return SvgPicture.asset(
            path,
            colorFilter: ColorFilter.mode(
              Color(_curentIndex == index ? 0xff15B86C : 0xffC6C6C6),
              BlendMode.srcIn,
            ),
          );
  }
}
