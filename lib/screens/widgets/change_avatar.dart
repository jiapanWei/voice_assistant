import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import 'package:voice_assistant/screens/widgets/build_logger_style.dart';

// Define ChangeUserAvatar class that used for changing the user's avatar
class ChangeUserAvatar {
  // Define the logger for logging errors
  final Logger logger = LoggerStyle.getLogger();

  // Method for picking an image from the gallery
  Future<void> pickImage(User currentUser, CollectionReference userCollection) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      // If an image was picked, upload it
      if (image != null) {
        await uploadImage(image, currentUser, userCollection);
      }
    } catch (e) {
      logger.e('Error picking image: $e');
    }
  }

  // Method for uploading the picked image
  Future<void> uploadImage(
      XFile image, User currentUser, CollectionReference userCollection) async {
    try {
      // Create a reference to the location in Firebase Storage where the image will be stored
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('user_avatars')
          .child('${currentUser.uid}.jpg');

      // Upload the image to the Firebase storage
      await storageReference.putFile(File(image.path));

      // Get the download URL of the uploaded image
      final downloadUrl = await storageReference.getDownloadURL();

      // Update the user's avatar in the Firestore database
      await userCollection.doc(currentUser.uid).update({'avatar': downloadUrl});
    } catch (e) {
      logger.e('Error uploading image: $e');
    }
  }
}
