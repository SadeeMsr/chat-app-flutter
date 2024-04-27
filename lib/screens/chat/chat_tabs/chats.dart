import 'package:chat_application_iub_cse464/const_config/text_config.dart';
import 'package:chat_application_iub_cse464/widgets/chat_bubble.dart';
import 'package:chat_application_iub_cse464/widgets/custom_buttons/Rouded_Action_Button.dart';
import 'package:chat_application_iub_cse464/widgets/input_widgets/simple_input_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../const_config/color_config.dart';
import '../../../services/chat_service.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final firebase = FirebaseFirestore.instance;
  final messageController = TextEditingController();

Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: MyColor.scaffoldColor,
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: firebase.collection('chat').orderBy('time').snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.active) {
                  var data = snapshot.data.docs;
                  return data.length != 0
                      ? ListView.builder(
                          shrinkWrap: true, // Ensure the ListView takes only the necessary height
                          physics: NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            var message = snapshot.data.docs[index]['message'];
                            var name = snapshot.data.docs[index]['name'];
                            var isMyMessage = snapshot.data.docs[index]['uuid'] == FirebaseAuth.instance.currentUser!.uid;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: isMyMessage
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    // Wrap the Container with Flexible
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isMyMessage
                                            ? Colors.blue
                                            : Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child:
                                      ChatBubble(
                                        message: message,
                                        name: name,
                                        isCurrentUser: isMyMessage,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : const Center(child: Text("No Chats to show"));
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
        SimpleInputField(
          controller: messageController,
          hintText: "Aa..",
          needValidation: true,
          errorMessage: "Message box can't be empty",
          fieldTitle: "",
          needTitle: false,
        ),
        const SizedBox(
          height: 10,
        ),
        RoundedActionButton(
          onClick: () {
            ChatService().sendChatMessage(message: messageController.text);
          },
          label: "Send Message",
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}

}

