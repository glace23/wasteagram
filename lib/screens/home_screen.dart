import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteagram/components/navigator.dart';
import 'package:wasteagram/scaffold/wasteagram_scaffold.dart';
import 'package:wasteagram/screens/list_screen.dart';

class HomeScreen extends StatefulWidget {
  final SharedPreferences preferences;
  const HomeScreen({Key? key, required this.preferences}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getThemeState(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return getLayOut(snapshot.data);
          } else {
            return getLayOut(_notifier);
          }
        });
  }

  Future<ValueNotifier<ThemeMode>> getThemeState() async {
    if (widget.preferences.getString("themeState") ==
        ThemeMode.light.toString()) {
      return ValueNotifier(ThemeMode.light);
    } else {
      return ValueNotifier(ThemeMode.dark);
    }
  }

  Widget getLayOut(ValueNotifier<ThemeMode> listener) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: listener,
        builder: (_, mode, __) {
          return MaterialApp(
              title: 'Wasteagram',
              theme: ThemeData(primarySwatch: Colors.deepPurple),
              darkTheme: ThemeData.dark(),
              themeMode: mode,
              home: wasteagramScaffold(
                title: 'Wasteagram',
                screen: const ListScreen(),
                navigation: checkToNewPostScreen,
                icon: const Icon(Icons.add_a_photo),
                mode: mode,
                themeSwitch: listener,
                preferences: widget.preferences,
              ));
        });
  }
}
