import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:wasteagram/components/navigator.dart';
import 'package:wasteagram/models/FoodWastePost.dart';
import 'package:wasteagram/scaffold/wasteagram_scaffold.dart';
import 'package:wasteagram/components/PickImage.dart';

import '../components/format_functions.dart';

class NewPostScreen extends StatefulWidget {
  final dynamic image;
  const NewPostScreen({Key? key, this.image}) : super(key: key);

  @override
  State<NewPostScreen> createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  LocationData? locationData;
  var locationService = Location();
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  FoodWastePost foodWastePost = FoodWastePost();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return wasteagramScaffold(
        title: 'Create New Post',
        screen: newPostBody(),
        navigation: backToLastScreen,
        icon: const Icon(Icons.arrow_back));
  }

  // Widget postOrientation() {
  //   if (MediaQuery.of(context).size.width <
  //       MediaQuery.of(context).size.height) {
  //     return newPostBody();
  //   } else {
  //     return newPostBodyHortizontal();
  //   }
  // }

  Widget newPostBody() {
    if (locationData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView(children: [
        Form(
          key: formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  child: formWidgetPadding(
                    formWidget: Image.file(widget.image),
                    padding: 10,
                  ),
                  height: getScreenHeight(context) / 3,
                ),
                formWidgetPadding(formWidget: postTitle(), padding: 10),
                formWidgetPadding(formWidget: postQuantity(), padding: 10),
                formWidgetPadding(formWidget: postLongitude(), padding: 10),
                formWidgetPadding(formWidget: postLatitude(), padding: 10),
                SizedBox(
                  child: ElevatedButton(
                    child: const Text('Upload'),
                    onPressed: () {
                      // Share.shareFiles([image!.path],
                      //     text:
                      //         "Hey my location is ${locationData!.longitude}, ${locationData!.latitude}");
                      uploadData();
                    },
                  ),
                  width: getScreenWidth(context) / 2,
                ),
              ]),
        ),
      ]);
    }
  }

  // Widget newPostBodyHortizontal() {
  //   if (locationData == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else {
  //     return ListView(children: [
  //       Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
  //         SizedBox(
  //           child: Image.file(
  //             widget.image,
  //             width: getSize(context),
  //             height: getSize(context) / 1.5,
  //           ),
  //         ),
  //         Form(
  //           key: formKey,
  //           child: Column(children: [
  //             SizedBox(child: postTitle()),
  //             SizedBox(
  //                 child: Text(
  //               "${locationData!.longitude}\n${locationData!.latitude}",
  //               style: Theme.of(context).textTheme.headline4,
  //             )),
  //             SizedBox(
  //               child: ElevatedButton(
  //                 child: const Text('Upload'),
  //                 onPressed: () {
  //                   // Share.shareFiles([image!.path],
  //                   //     text:
  //                   //         "Hey my location is ${locationData!.longitude}, ${locationData!.latitude}");
  //                   uploadData();
  //                 },
  //               ),
  //               width: getSize(context) / 2,
  //             ),
  //           ]),
  //         ),
  //       ]),
  //     ]);
  //   }
  // }

  void uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      foodWastePost.imageURL = await PickImage().getImageURL(widget.image);
      foodWastePost.dateTime = DateTime.now();

      FirebaseFirestore.instance.collection('posts').add({
        'title': foodWastePost.title,
        'imageURL': foodWastePost.imageURL,
        'quantity': foodWastePost.quantity,
        'longitude': foodWastePost.longitude,
        'latitude': foodWastePost.latitude,
        'dateTime': foodWastePost.dateTime,
      });
      backToLastScreen(context);
    }
  }

  Widget postTitle() {
    String text = "Please Enter a Title";

    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Title',
        border: OutlineInputBorder(),
      ),
      onSaved: (value) {
        foodWastePost.title = value;
      },
      validator: (value) => validator(value, text),
    );
  }

  Widget postQuantity() {
    String text = "Please Enter a Quantity";

    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Quantity',
        border: OutlineInputBorder(),
      ),
      onSaved: (value) {
        foodWastePost.quantity = int.parse(value!);
      },
      validator: (value) => validator(value, text),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget postLongitude() {
    String text = "Please Enter a Longitude";

    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Longitude',
        border: OutlineInputBorder(),
      ),
      initialValue: locationData!.longitude.toString(),
      onSaved: (value) {
        foodWastePost.longitude = double.parse(value!);
      },
      validator: (value) => validator(value, text),
      readOnly: true,
    );
  }

  Widget postLatitude() {
    String text = "Please Enter a Latitude";

    return TextFormField(
      autofocus: true,
      decoration: const InputDecoration(
        labelText: 'Latitude',
        border: OutlineInputBorder(),
      ),
      initialValue: locationData!.latitude.toString(),
      onSaved: (value) {
        foodWastePost.latitude = double.parse(value!);
      },
      validator: (value) => validator(value, text),
      readOnly: true,
    );
  }

  String? validator(String? value, String text) {
    if (value!.isEmpty) {
      return text;
    } else {
      return null;
    }
  }
}