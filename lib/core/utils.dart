import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:x_clone/core/common/error_page.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final List<XFile?> imageFiles = await picker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(
        File(image!.path),
      );
    }
  } else {
    const ErrorText(error: 'You can only select a maximum of 2 images');
  }
  return images;
}

Future<XFile?> pickImage() async {
  final image = await ImagePicker.platform
      .getImageFromSource(source: ImageSource.gallery);

  return image;
}
