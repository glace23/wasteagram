import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:wasteagram/models/FoodWastePost.dart';
import '../components/format_functions.dart';
import '../components/navigator.dart';
import '../scaffold/wasteagram_scaffold.dart';
import 'dart:io';

class ReadPostScreen extends StatefulWidget {
  final FoodWastePost foodWastePost;
  const ReadPostScreen({
    Key? key,
    required this.foodWastePost,
  }) : super(key: key);

  @override
  _ReadPostScreen createState() => _ReadPostScreen();
}

class _ReadPostScreen extends State<ReadPostScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return wasteagramScaffold(
      title: widget.foodWastePost.title!,
      screen: postBody(),
      navigation: backToLastScreen,
      icon: const Icon(Icons.arrow_back),
    );
  }

  Widget postBody() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Center(
                  child: Text(
                      'Date: ${widget.foodWastePost.dateTime.toString().substring(0, 10)}')),
              subtitle: Center(
                  child: Text(
                      'Location: ${widget.foodWastePost.longitude.toString()}, ${widget.foodWastePost.latitude.toString()}')),
            ),
            SizedBox(
              child: formWidgetPadding(
                formWidget: Image.network(widget.foodWastePost.imageURL!),
                padding: 10,
              ),
              height: getScreenHeight(context) / 2,
            ),
            Text(
              "Quantity: ${widget.foodWastePost.quantity.toString()}",
              style: const TextStyle(fontSize: 25),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            button(
                buttonName: "Share",
                function: () {
                  Share.share(widget.foodWastePost.toString());
                }),
            button(buttonName: "Delete", function: promptDeletePost),
          ],
        )
      ],
    );
  }

  Widget button({required String buttonName, required function, var param}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: ElevatedButton(
          child: Text(buttonName),
          onPressed: () {
            if (param == null) {
              function();
            } else {
              function(param);
            }
          },
        ),
      ),
    );
  }

  void promptDeletePost() {
    popUpDialogue(
        title: "Delete Post",
        description: "Are you sure you want to delete this post?",
        context: context);
  }

  void deletePost() {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.foodWastePost.id)
        .delete();
    backToLastScreen(context);
  }

  Future<String?> popUpDialogue({
    required String title,
    required String description,
    required BuildContext context,
  }) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: <Widget>[
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.48,
            child: TextButton(
              onPressed: () {
                deletePost();
                Navigator.pop(context, 'Yes');
              },
              child: const Text('Yes'),
            ),
          ),
          FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: 0.48,
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'No'),
              child: const Text('No'),
            ),
          ),
        ],
      ),
    );
  }
}
