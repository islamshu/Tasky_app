import 'package:flutter/material.dart';
import 'package:flutter_projects/features/home/home_screen.dart';
import 'package:flutter_projects/features/navigation/main_screen.dart';
import 'package:flutter_projects/features/welcom/welcom_screen.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';
import 'package:flutter_projects/core/themes/dark_theme.dart';
import 'package:flutter_projects/core/themes/light_theme.dart';
import 'package:flutter_projects/core/themes/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final pref = await SharedPreferences.getInstance();
  // pref.clear();
  // String? userName = pref.getString("userName");

  await PreferenceManger().init();
  ThemeController().init();
  String? userName = PreferenceManger().getString("userName");


  runApp(MyApp(userName: userName));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.userName});

  final String? userName;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode value, Widget? child) {
        return MaterialApp(
          title: 'Tasky',
          darkTheme: darkTheme,
          theme: lightTheme,
          themeMode: value,
          home: userName == null ? WelcomScreen() : MainScreen(),
        );
      },
    );
  }
}
