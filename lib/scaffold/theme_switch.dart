import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitch extends StatefulWidget {
  final ValueNotifier<ThemeMode> themeSwitch;
  final ThemeMode mode;
  final SharedPreferences preferences;
  const ThemeSwitch(
      {Key? key,
      required this.themeSwitch,
      required this.mode,
      required this.preferences})
      : super(key: key);

  @override
  _ThemeSwitchState createState() => _ThemeSwitchState();
}

class _ThemeSwitchState extends State<ThemeSwitch> {
  late bool _themeMode = false;
  String key = 'Theme';

  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Dark Mode'),
      value: _themeMode,
      onChanged: (bool value) {
        if (_themeMode == false) {
          widget.themeSwitch.value = ThemeMode.dark;
        } else {
          widget.themeSwitch.value = ThemeMode.light;
        }
        setState(() {
          _themeMode = value;
          saveSwitchState(value);
          saveThemeState();
        });
      },
      secondary: const Icon(Icons.dark_mode_outlined),
    );
  }

  void getSwitchValues() async {
    _themeMode = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    widget.preferences.setBool("switchState", value);
    return widget.preferences.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    if (widget.preferences.getBool("switchState") == null) {
      if (widget.mode == ThemeMode.dark) {
        widget.preferences.setBool("switchState", true);
      } else {
        widget.preferences.setBool("switchState", false);
      }
    }
    bool isSwitched = widget.preferences.getBool("switchState")!;
    return isSwitched;
  }

  void getThemeValues() async {
    _themeMode = await getSwitchState();
    setState(() {});
  }

  void saveThemeState() async {
    widget.preferences
        .setString("themeState", widget.themeSwitch.value.toString());
  }
}
