import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:geocoding/geocoding.dart';
import '../models/food_waste_post.dart';
import '../models/collection.dart';
import '../components/format_functions.dart';
import '../components/navigator.dart';
import '../scaffold/wasteagram_scaffold.dart';

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
    getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return wasteagramScaffold(
      title: widget.foodWastePost.title!,
      screen: postBody(),
      navigation: backToLastScreen,
      haveButton: false,
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
            Semantics(
              child: postWasteCount(),
              label: "A count of waste",
              readOnly: true,
            ),
            Semantics(
              child: postImage(),
              label: "An image of waste",
              enabled: true,
              readOnly: true,
              image: true,
            ),
            Semantics(
              child: postDetails(),
              label: "Title, date, and location of waste",
              readOnly: true,
            ),
          ],
        ),
        Semantics(
          child: postButtons(),
          button: true,
          label: "Row for buttons",
          onTapHint: "Share post information or delete post from list",
        ),
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
        .collection(Collection().name)
        .doc(widget.foodWastePost.id)
        .delete();
    backToLastScreen(context);
  }

  Future<List<Placemark>> getLocation() async {
    return await placemarkFromCoordinates(
        widget.foodWastePost.latitude!, widget.foodWastePost.longitude!);
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

  Widget postWasteCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.recycling),
        Text(
          ": ${widget.foodWastePost.quantity.toString()}",
          style: const TextStyle(fontSize: 25),
        ),
      ],
    );
  }

  Widget postImage() {
    return SizedBox(
      child: formWidgetPadding(
        formWidget: Image.network(widget.foodWastePost.imageURL!),
        padding: 10,
      ),
      height: getScreenHeight(context) / 2,
    );
  }

  Widget postDetails() {
    return ListTile(
      title: Center(
        child: Text(
          widget.foodWastePost.title!,
          style: const TextStyle(fontSize: 25),
        ),
      ),
      subtitle: Center(
        child: FutureBuilder(
          future: getLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Text(
                      DateFormat.yMMMd().format(widget.foodWastePost.dateTime!),
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white, height: 2)),
                  Text(
                      "${snapshot.data[0].locality}, ${snapshot.data[0].administrativeArea}, ${snapshot.data[0].isoCountryCode}, ${snapshot.data[0].postalCode}"),
                  Text(
                      "Coordinates: (${widget.foodWastePost.longitude}, ${widget.foodWastePost.latitude})")
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget postButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        button(
            buttonName: "Share",
            function: () {
              Share.share(widget.foodWastePost.toString());
            }),
        button(buttonName: "Delete", function: promptDeletePost),
      ],
    );
  }
}
