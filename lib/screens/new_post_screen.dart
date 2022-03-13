import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/collection.dart';
import '../components/navigator.dart';
import '../models/food_waste_post.dart';
import '../scaffold/wasteagram_scaffold.dart';
import '../components/PickImage.dart';
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

  @override
  Widget build(BuildContext context) {
    return wasteagramScaffold(
        title: 'Create New Post',
        screen: newPostBody(),
        navigation: backToLastScreen,
        haveButton: false,
        icon: const Icon(Icons.arrow_back));
  }

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          // Prompt user location service permission not enabled
          popUpDialogue(
              title: "Location Service Not Enabled!",
              description:
                  "Location Service Not Enabled! Please enable location Service in the settings!",
              context: context);
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
          // Prompt user location service permission not granted
          popUpDialogue(
              title: "Location Service Permission Denied!",
              description:
                  "Location service premission not granted! Please enable permission to use location Service!",
              context: context);
          return;
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

  Widget newPostBody() {
    if (locationData == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ListView(children: [
        Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Semantics(
              child: postImage(),
              image: true,
              label: "An image of waste",
            ),
            Semantics(
              child: formWidgetPadding(formWidget: postTitle(), padding: 10),
              label: "User input title for post",
              readOnly: false,
            ),
            Semantics(
              child: formWidgetPadding(formWidget: postQuantity(), padding: 10),
              label: "User input count of waste for post",
              readOnly: false,
              value: "Digits only",
            ),
            Semantics(
              child:
                  formWidgetPadding(formWidget: postLongitude(), padding: 10),
              label: "User longitude value for post",
              readOnly: true,
            ),
            Semantics(
              child: formWidgetPadding(formWidget: postLatitude(), padding: 10),
              label: "User latitude value for post",
              readOnly: true,
            ),
            Semantics(
              child: postUpload(),
              label: "Uploads data to firestore",
              onTapHint:
                  "Uploads data to firestore database collection Collection().name",
              onTap: uploadData,
            ),
          ]),
        ),
      ]);
    }
  }

  void uploadData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState?.save();

      foodWastePost.imageURL = await PickImage().getImageURL(widget.image);
      foodWastePost.dateTime = DateTime.now();

      FirebaseFirestore.instance.collection(Collection().name).add({
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

  Widget postImage() {
    return SizedBox(
      child: formWidgetPadding(
        formWidget: Image.file(widget.image),
        padding: 10,
      ),
      height: getScreenHeight(context) / 3,
    );
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
      keyboardType: TextInputType.number,
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

  Widget postUpload() {
    return SizedBox(
      child: ElevatedButton(
        child: const Text('Upload'),
        onPressed: () {
          uploadData();
        },
      ),
      width: getScreenWidth(context) / 2,
    );
  }

  String? validator(String? value, String text) {
    if (value!.isEmpty) {
      return text;
    } else {
      return null;
    }
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
            widthFactor: 1,
            child: TextButton(
              onPressed: () {
                Navigator.pop(context, 'OK');
                backToLastScreen(context);
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
