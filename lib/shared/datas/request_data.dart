import 'package:cloud_firestore/cloud_firestore.dart';

class RequestData {
  String? id;
  late String? pix;
  late String? city;
  late String? status;
  late String? address;
  late String? creator;
  late String? requester;
  late String? lastEditor;
  late String? description;
  late String? neighborhood;

  RequestData(
      {id,
      this.pix,
      this.city,
      this.status,
      this.address,
      this.creator,
      this.requester,
      this.lastEditor,
      this.description,
      this.neighborhood}) {
    if (id != null) {
      this.id = id;
    }
  }

  RequestData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.id;
    pix = snapshot["pix"];
    city = snapshot["city"];
    status = snapshot["status"];
    address = snapshot["address"];
    creator = snapshot["creator"];
    requester = snapshot["requester"];
    lastEditor = snapshot["lastEditor"];
    description = snapshot["description"];
    neighborhood = snapshot["neighborhood"];
  }

  Map<String, dynamic> toMap(RequestData request) {
    return {
      "pix": request.pix,
      "city": request.city,
      "status": request.status,
      "address": request.address,
      "creator": request.creator,
      "requester": request.requester,
      "lastEditor": request.lastEditor,
      "description": request.description,
      "neighborhood": request.neighborhood
    };
  }
}
