import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? id;
  late String name;
  late String email;
  late String phone;
  late String age;
  late String picture;

  UserData(
      {id,
      required this.name,
      required this.email,
      required this.phone,
      required this.age,
      required this.picture}) {
    if (id != null) {
      this.id = id;
    }
  }

  UserData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    name = snapshot["name"];
    email = snapshot["email"];
    phone = snapshot["phone"];
    age = snapshot["age"];
    picture = snapshot["picture"];
  }

  Map<String, dynamic> toMap(UserData user) {
    return {
      "name": user.name,
      "email": user.email,
      "phone": user.phone,
      "age": user.age,
      "picture": user.picture
    };
  }
}
