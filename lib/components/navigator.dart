import 'package:flutter/material.dart';
import '../components/PickImage.dart';
import '../models/food_waste_post.dart';
import '../screens/new_post_screen.dart';
import '../screens/read_post_screen.dart';

void toAddNewPostScreen(BuildContext context, dynamic image) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => NewPostScreen(image: image),
  ));
}

void checkToNewPostScreen(BuildContext context) async {
  final image = await PickImage().getImage(context: context);
  if (image != null) {
    toAddNewPostScreen(context, image);
  }
}

void toReadPostScreen(BuildContext context, FoodWastePost foodWastePost) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => ReadPostScreen(foodWastePost: foodWastePost),
  ));
}

void backToLastScreen(BuildContext context) {
  Navigator.of(context).pop();
}
