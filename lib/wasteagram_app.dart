import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/vertical_layout.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences preferences;
  const MyApp({Key? key, required this.preferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerticalLayout(preferences: preferences);
  }

  Future<ValueNotifier<ThemeMode>> getThemeState() async {
    if (preferences.getString("themeState") == ThemeMode.light.toString()) {
      return ValueNotifier(ThemeMode.light);
    } else {
      return ValueNotifier(ThemeMode.dark);
    }
  }
}
