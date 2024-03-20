import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChangeUserAvatar {
  Future<void> pickImage(
      User currentUser, CollectionReference userCollection) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        await uploadImage(image, currentUser, userCollection);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage(
      XFile image, User currentUser, CollectionReference userCollection) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${currentUser.uid}.jpg');

      await storageReference.putFile(File(image.path));

      final downloadUrl = await storageReference.getDownloadURL();

      await userCollection.doc(currentUser.uid).update({'avatar': downloadUrl});
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
