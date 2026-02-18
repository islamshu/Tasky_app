import 'package:flutter/material.dart';
import 'package:flutter_projects/core/services/preference_manger.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  init()  {
    bool result =  PreferenceManger().getBool("theme") ?? true;
    if (result) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }
  }
  static toggelTheme() async{
    if(themeNotifier.value == ThemeMode.dark){
      themeNotifier.value = ThemeMode.light;
    await  PreferenceManger().setBool("theme",false);
    }else{
      themeNotifier.value = ThemeMode.dark;
      await  PreferenceManger().setBool("theme",true);
    }
  }
 static bool isDark ()=> themeNotifier.value == ThemeMode.dark;

}
