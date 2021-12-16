import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RequestCard extends StatefulWidget {
  final UserModel model;
  RequestData request = RequestData();

  RequestCard(this.model, this.request, {Key? key}) : super(key: key);

  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  String? userAvatar;

  @override
  Widget build(BuildContext context) {
    widget.model.getUserAvatar(widget.request.creator).then((avatar) {
      setState(() {
        userAvatar = avatar;
      });
    });

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).backgroundColor,
          child: ClipOval(
            child: userAvatar != null
                ? Image(
                    fit: BoxFit.fitHeight,
                    image: AssetImage(userAvatar!),
                  )
                : Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
          ),
        ),
        title: Text(widget.request.requester! + " - " + widget.request.city!),
        subtitle: Text(
          widget.request.description!,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.edit),
        onTap: () => _openRequestDetails(),
      ),
    );
  }

  void _openRequestDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Detalhes do auxilio',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: GestureDetector(
            child: const SizedBox(
              height: 250,
              width: 250,
            ),
            onTap: () => Navigator.pop(context),
          ),
        );
      },
    );
  }
}
