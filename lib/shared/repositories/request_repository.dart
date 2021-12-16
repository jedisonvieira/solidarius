import 'package:cloud_firestore/cloud_firestore.dart';

class RequestReposiroty {
  Future<void> saveRequest(
      {String? id, required Map<String, dynamic> requestData}) async {
    if (id == null) {
      FirebaseFirestore.instance
          .collection("requests")
          .add(requestData)
          .then((category) {})
          .catchError((error) {
        print(error);
      });
    } else {
      FirebaseFirestore.instance
          .collection("requests")
          .doc(id)
          .update(requestData)
          .then((expense) {})
          .catchError((error) {
        print(error);
      });
    }
  }
}
