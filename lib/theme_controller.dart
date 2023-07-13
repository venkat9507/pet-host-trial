import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:pet_adoption_app/colors.dart';

class ThemeController extends GetxController {
  final Box<String> themeBox = Hive.box<String>('theme');
  final currentTheme = ThemeData.light().obs;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  final darkTheme = <String, dynamic>{
    "appBarTheme": const AppBarTheme(
      color: AssetColors.darkThemeAppBarThemeColor,
    ),
    "switchThemeData": SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.hovered)) {
            return AssetColors.darkThemeSwitchThumbHoverColor;
          }
          return AssetColors.darkThemeSwitchThumbFixedColor;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.hovered)) {
            return AssetColors.darkThemeSwitchTrackHoverColor;
          }
          return AssetColors.darkThemeSwitchTrackFixedColor;
        },
      ),
    ),
  };

  final lightTheme = <String, dynamic>{
    "appBarTheme": const AppBarTheme(
      color: AssetColors.lightThemeAppBarThemeColor,
    ),
    "switchThemeData": SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.hovered)) {
            return AssetColors.lightThemeSwitchThumbHoverColor;
          }
          return AssetColors.lightThemeSwitchThumbFixedColor;
        },
      ),
      trackColor: MaterialStateProperty.resolveWith(
        (states) {
          if (states.contains(MaterialState.hovered)) {
            return AssetColors.lightThemeSwitchTrackHoverColor;
          }
          return AssetColors.lightThemeSwitchTrackFixedColor;
        },
      ),
    )
  };

  void getThemeValue(String? themeMode) {
    if (themeMode == 'dark') {
      currentTheme.value = ThemeData(
        appBarTheme: darkTheme["appBarTheme"],
        brightness: Brightness.dark,
        switchTheme: darkTheme["switchThemeData"],
        scaffoldBackgroundColor: Color(0xff707070),
        dialogBackgroundColor: Color(0xFF909090),
      );
    } else {
      currentTheme.value = ThemeData(
        appBarTheme: lightTheme["appBarTheme"],
        brightness: Brightness.light,
        switchTheme: lightTheme["switchThemeData"],
        scaffoldBackgroundColor: Color(0xffD1D1D1),
        dialogBackgroundColor: Color(0xFFA1A1A1),
      );
    }
  }

  void _loadTheme() {
    final themeModeStr = themeBox.get('themeMode');
    getThemeValue(themeModeStr);
  }

  void setThemeMode(ThemeMode themeMode) {
    final themeModeStr = themeMode == ThemeMode.dark ? 'dark' : 'light';
    themeBox.put('themeMode', themeModeStr);
    getThemeValue(themeModeStr);
  }

  bool get isDarkMode {
    return themeBox.get('themeMode') == 'dark';
  }

  
}
