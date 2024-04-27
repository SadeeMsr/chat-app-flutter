
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserData userDataFromMap(String str) => UserData.fromMap(json.decode(str));

String userDataToMap(UserData data) => json.encode(data.toMap());

class UserData {
  String? name;
  String? uuid;
  String? email;
  Timestamp? lastLogin;
  List<dynamic>? myChats;

  UserData({
    this.name,
    this.uuid,
    this.email,
    this.myChats,
    this.lastLogin,
  });

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
    name: json["name"],
    uuid: json["uuid"],
    email: json["email"],
    lastLogin: json["lastLogin"],
    myChats: json["my_chats"] == null ? [] : List<dynamic>.from(json["my_chats"]!.map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "uuid": uuid,
    "email": email,
    "lastLogin": lastLogin,
    "my_chats": myChats == null ? [] : List<dynamic>.from(myChats!.map((x) => x)),
  };
}
