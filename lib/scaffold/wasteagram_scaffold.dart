import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/collection.dart';
import 'theme_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Scaffold wasteagramScaffold({
  required String title,
  required Widget screen,
  required Function navigation,
  required Widget icon,
  ThemeMode? mode,
  ValueNotifier<ThemeMode>? themeSwitch,
  SharedPreferences? preferences,
  bool haveButton = true,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Column(children: [const Text('Wastagram'), quantityCounter()]),
      centerTitle: true,
    ),
    body: screen,
    endDrawer: themeSwitch != null
        ? settingsDrawer(mode, themeSwitch, preferences)
        : null,
    floatingActionButton: haveButton == true
        ? Builder(builder: (context) {
            return FloatingActionButton(
              child: icon,
              onPressed: () => navigation(context),
            );
          })
        : null,
  );
}

Widget quantityCounter() {
  return StreamBuilder(
    stream:
        FirebaseFirestore.instance.collection(Collection().name).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData &&
          snapshot.data!.docs != null &&
          snapshot.data!.docs.isNotEmpty) {
        int quantity = 0;
        for (var element in snapshot.data!.docs) {
          quantity += int.parse(element.get('quantity').toString());
        }
        return Text(
          'Waste Count: ${quantity.toString()}',
          style: const TextStyle(color: Colors.red),
        );
      }
      return const Text(
        'Count: 0',
        style: TextStyle(color: Colors.green),
      );
    },
  );
}

Widget settingsDrawer(
  final mode,
  ValueNotifier<ThemeMode>? themeSwitch,
  SharedPreferences? preferences,
) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: mode == ThemeMode.light
              ? const BoxDecoration(color: Colors.deepPurple)
              : const BoxDecoration(),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            Icon(
              Icons.settings,
              color: Colors.white,
            ),
            Text(" Settings", style: TextStyle(color: Colors.white)),
          ]),
        ),
        ThemeSwitch(
            themeSwitch: themeSwitch!, mode: mode, preferences: preferences!),
      ],
    ),
  );
}
