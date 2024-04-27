import 'package:chat_application_iub_cse464/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_avatar/random_avatar.dart';

// Import UserData model

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  bool isActive(Timestamp? lastLogin) {
    if (lastLogin != null) {
      final now = Timestamp.now().toDate();
      final lastLoginDate = lastLogin.toDate();
      final difference = now.difference(lastLoginDate).inMinutes;
      return difference <= 5;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Use desired background color
      appBar: AppBar(
        title: const Text('Discover Users'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          }

          // Extract user data from snapshot
          final List<UserData> users = snapshot.data!.docs
              .map(
                  (doc) => UserData.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final UserData user = users[index];
              final Color backgroundColor = index % 2 == 0
                  ? Colors.grey[200]!
                  : Colors.white; // Alternate background colors
              return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0), // Add vertical padding
                child: Container(
                  color: backgroundColor,
                  child: ListTile(
                    leading: RandomAvatar(
                      user.name ?? '',
                      height: 50, // Set desired height for the avatar
                      width: 50, // Set desired width for the avatar
                    ),
                    title: Row(
                      children: [
                        Text(user.name ?? ''),
                        const SizedBox(width: 10),
                        isActive(user.lastLogin)
                            ? const Icon(Icons.circle,
                                color: Colors.green, size: 12)
                            : const Icon(Icons.circle,
                                color: Colors.grey, size: 12),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.email ?? ''),
                        FutureBuilder<DocumentSnapshot>(
                          future: _firebaseFirestore
                              .collection('users')
                              .doc(user.uuid)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('Loading...');
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              final lastLogin =
                                  snapshot.data!.get('lastLogin');
                              final formattedLastLogin = lastLogin != null
                                  ? DateFormat('MMM dd, yyyy')
                                      .format(lastLogin.toDate())
                                  : 'N/A';
                              return Text(
                                  'Last logged in: $formattedLastLogin');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
