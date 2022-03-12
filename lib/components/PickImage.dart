import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PickImage {
  File? _image;
  final _picker = ImagePicker();

  Future<File?> getImage({required BuildContext context}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      _image = null;
    }
    return _image;
  }

  Future<String> getImageURL(File image) async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask;
    final url = await storageReference.getDownloadURL();
    return url;
  }

  File? getCurrentImage() {
    return _image;
  }
}
