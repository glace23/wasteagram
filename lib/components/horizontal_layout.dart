// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../components/navigator.dart';

// class HorizontalLayout extends StatelessWidget {
//   final SharedPreferences preferences;
//   HorizontalLayout({Key? key, required this.preferences}) : super(key: key);
//   final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: getThemeState(),
//         builder: (context, AsyncSnapshot snapshot) {
//           if (snapshot.hasData) {
//             return getLayOut(snapshot.data);
//           } else {
//             return getLayOut(_notifier);
//           }
//         });
//   }

//   Future<ValueNotifier<ThemeMode>> getThemeState() async {
//     if (preferences.getString("themeState") == ThemeMode.light.toString()) {
//       return ValueNotifier(ThemeMode.light);
//     } else {
//       return ValueNotifier(ThemeMode.dark);
//     }
//   }

//   Widget getLayOut(ValueNotifier<ThemeMode> listener) {
//     return ValueListenableBuilder<ThemeMode>(
//         valueListenable: listener,
//         builder: (_, mode, __) {
//           return MaterialApp(
//               title: 'Journal',
//               theme: ThemeData(primarySwatch: Colors.deepPurple),
//               darkTheme: ThemeData.dark(),
//               themeMode: mode,
//               home: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: journalScaffold(
//                         title: "Journals",
//                         screen: const JournalListScreen(),
//                         navigation: toAddJournalScreen,
//                         icon: const Icon(Icons.note_add),
//                         mode: mode,
//                         themeSwitch: listener,
//                         preferences: preferences,
//                         haveButton: false),
//                   ),
//                   const Expanded(
//                     child: JournalEntryForm(haveButton: false, MAX_LINES: 2),
//                   ),
//                 ],
//               ));
//         });
//   }
// }
