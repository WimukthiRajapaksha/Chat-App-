import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File? pickedImage) imagePickerFn;

  UserImagePicker({required this.imagePickerFn});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  XFile? _pickedImage;

  void _pickImage() async {
    final imagePic = ImagePicker();
    final photo = await imagePic.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );
    setState(() {
      this._pickedImage = photo;
    });
    widget.imagePickerFn(
        this._pickedImage == null ? null : File(this._pickedImage!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: (this._pickedImage != null)
              ? FileImage(File(this._pickedImage!.path))
              : null,
          radius: 40,
        ),
        FlatButton.icon(
          onPressed: this._pickImage,
          icon: Icon(Icons.image),
          label: Text("Add Image"),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
