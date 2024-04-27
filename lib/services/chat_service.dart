import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message_model.dart';

class ChatService {
  final auth = FirebaseAuth.instance;
  final firebase = FirebaseFirestore.instance;

  Future<String> getCurrentUserName() async {
    final currentUserID = auth.currentUser!.uid;
    final userData =
        await firebase.collection('users').doc(currentUserID).get();

    final userDataMap = userData.data() as Map<String, dynamic>;
    print(userDataMap['name']);
    return userDataMap['name'];
  }

  Future<void> sendChatMessage({required String message}) async {
    final userName = await getCurrentUserName();
    print(userName);
    var messageModel = MessageModel(
        name: userName,
        message: message,
        uuid: auth.currentUser!.uid.toString(),
        time: Timestamp.now());

    await firebase.collection('chat').add(messageModel.toMap());
  }
}
