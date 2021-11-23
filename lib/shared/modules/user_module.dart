import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? id;
  late String name;
  late String email;
  late String phone;
  late String age;
  late String picture;

  UserModel(
      {id,
      required this.name,
      required this.email,
      required this.phone,
      required this.age,
      required this.picture}) {
    if (!id == null) {
      this.id = id;
    }
  }

  UserModel.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot["name"];
    email = snapshot["email"];
    phone = snapshot["phone"];
    age = snapshot["age"];
    picture = snapshot["picture"];
  }

  Map<String, dynamic> toMap(UserModel user) {
    return {
      "name": user.name,
      "email": user.email,
      "phone": user.phone,
      "age": user.age,
      "picture": user.picture
    };
  }
}
