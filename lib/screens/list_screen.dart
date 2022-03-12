import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasteagram/components/navigator.dart';
import 'package:wasteagram/models/FoodWastePost.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return listBuilder();
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
