import 'package:chat_application_iub_cse464/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserManage {
  final firebase = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String userName,
    required String userEmail,
    required String userID,
  }) async {
    var user = UserData(
      name: userName,
      uuid: userID,
      email: userEmail,
    );

    await firebase.collection("users").doc(userID).set(user.toMap());
  }

  Future<void> updateUserLastLogin(String userID) async {
    await firebase.collection("users").doc(userID).update({
      "last_login": Timestamp.now(), // Update last_login field with current timestamp
    });
  }
}
