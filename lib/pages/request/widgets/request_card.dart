import 'package:solidarius/pages/request/widgets/request_form_page.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/util/constants.dart';
import 'package:flutter/material.dart';

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
        title: Text('${widget.request.city!} - ${widget.request.requester!}'),
        subtitle: Text(
          widget.request.description!,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(
          Icons.warning,
          color: Constants.yellow,
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  RequestFormPage(widget.model, requestData: widget.request)));
        },
      ),
    );
  }
}
