import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class StoreData {
  User? currentUser = FirebaseAuth.instance.currentUser;

  Future<String> uploadImagetoStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required String name,
    required String greeting,
    required Uint8List file,
    required Uint8List uptoimage,
    required String upto,
    required String email,
    required String question,

  }) async {
    String resp = " Some Error Occurred ";

    try{

      if(name.isNotEmpty || greeting.isNotEmpty) {
        String imageUrl = await uploadImagetoStorage(email, file);
        final Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
        final downloadUrl = await ref.getDownloadURL();

        String filename = "${email}_upto";
        String upToUrl = await uploadImagetoStorage(filename, uptoimage);
        final Reference upToRef = FirebaseStorage.instance.refFromURL(upToUrl);
        final upToDownloadUrl = await upToRef.getDownloadURL();

        final docRef = FirebaseFirestore.instance.collection('User').doc(email);
        await docRef.update({
          'username': name,
          'greeting': greeting,
          'pfpimage': downloadUrl,
          'uptoimage': upToDownloadUrl,
        });

        resp = 'success';
      }
    }
        catch(err){
          resp = err.toString();
        }
        return resp;
  }
}
