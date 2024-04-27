import 'package:flutter/material.dart';


class ChatBubble extends StatelessWidget {
  final String message;
  final String name;
  final bool isCurrentUser;
  final Key? key; // Add named key parameter

  const ChatBubble({
    required this.message,
    required this.name,
    required this.isCurrentUser,
    this.key, // Initialize key parameter
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adjust spacing between message and avatar
        if (!isCurrentUser) ...[
          CircleAvatar(
            // Generate avatar based on message content
            child: Text(name[0].toUpperCase()+name[1].toUpperCase()),
          ),
          const SizedBox(width: 8), // Add spacing between avatar and message
        ],
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isCurrentUser ? Colors.blue : Colors.grey,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(
                color: Color.fromARGB(255, 229, 229, 231),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

