import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void displayMessageToUser(String message, BuildContext context){
  showDialog(
      context: context,
      builder: (context) => AlertDialog(title: Text(message),
      ),
  );
}

pickImage(ImageSource source) async{
  final ImagePicker imagePicker = ImagePicker();
  XFile? _file = await imagePicker.pickImage(source: source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  else{
    print('No images Selected');
  }
}