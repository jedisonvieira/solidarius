import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? id;
  late String? name;
  late String? email;
  late String? phone;
  late String? age;
  late String? avatar;

  UserData({id, this.name, this.email, this.phone, this.age, this.avatar}) {
    if (id != null) {
      this.id = id;
    }
  }

  UserData.fromMap(Map<String, dynamic>? map) {
    name = map!["name"];
    email = map["email"];
    phone = map["phone"];
    age = map["age"];
    avatar = map["avatar"];
  }

  UserData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot["name"];
    email = snapshot["email"];
    phone = snapshot["phone"];
    age = snapshot["age"];
    avatar = snapshot["avatar"];
  }

  Map<String, dynamic> toMap(UserData user) {
    return {
      "name": user.name,
      "email": user.email,
      "phone": user.phone,
      "age": user.age,
      "avatar": user.avatar
    };
  }
}
