import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RequestReposiroty {
  Future<void> saveRequest(
      {String? id, required Map<String, dynamic> requestData}) async {
    if (id == null) {
      FirebaseFirestore.instance
          .collection("requests")
          .add(requestData)
          .then((request) {})
          .catchError((error) {});
    } else {
      FirebaseFirestore.instance
          .collection("requests")
          .doc(id)
          .update(requestData)
          .then((request) {})
          .catchError((error) {});
    }
  }

  Future<void> deleteRequest(
      {required String id,
      required VoidCallback onSuccess,
      required Function(dynamic erro) onFail}) async {
    FirebaseFirestore.instance
        .collection("requests")
        .doc(id)
        .delete()
        .then((deletou) => {onSuccess()})
        .catchError((error) {
      onFail(error);
    });
  }
}
