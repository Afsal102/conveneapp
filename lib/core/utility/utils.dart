import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File?> pickImage(ImageSource source) async {
  File? image;
  final pickedImage = await ImagePicker().pickImage(source: source);
  if (pickedImage != null) {
    image = File(pickedImage.path);
  }
  return image;
}
