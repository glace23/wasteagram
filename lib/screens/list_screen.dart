import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasteagram/components/navigator.dart';
import 'package:wasteagram/scaffold/wasteagram_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/models/FoodWastePost.dart';

class ListScreen extends StatefulWidget {
  final SharedPreferences preferences;
  const ListScreen({Key? key, required this.preferences}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreen();
}

class _ListScreen extends State<ListScreen> {
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
                screen: listBuilder(),
                navigation: checkToNewPostScreen,
                icon: const Icon(Icons.add_a_photo),
                mode: mode,
                themeSwitch: listener,
                preferences: widget.preferences,
              ));
        });
  }

  Widget listBuilder() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.docs != null &&
            snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];

                FoodWastePost foodWastePost = FoodWastePost();
                foodWastePost.title = post['title'];
                foodWastePost.quantity = post['quantity'];
                foodWastePost.imageURL = post['imageURL'];
                foodWastePost.longitude = post['longitude'].toDouble();
                foodWastePost.latitude = post['latitude'].toDouble();
                foodWastePost.dateTime = post['dateTime'].toDate();
                foodWastePost.id = post.id;

                return ListTile(
                  title: Text(foodWastePost.title!),
                  subtitle: Text(
                      "Date: ${foodWastePost.dateTime!.toString().substring(0, 10)}, Quantity ${foodWastePost.quantity}, "
                      "\nLocation: ${foodWastePost.longitude}, ${foodWastePost.latitude}"),
                  onTap: () {
                    toReadPostScreen(context, foodWastePost);
                  },
                  trailing: Image.network(foodWastePost.imageURL!),
                );
              });
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
