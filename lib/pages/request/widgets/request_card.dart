import 'package:solidarius/pages/request/widgets/request_form_page.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:solidarius/shared/repositories/request_repository.dart';
import 'package:solidarius/shared/util/constants.dart';

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

  void _showOptions(BuildContext context, RequestData request) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () => {},
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.edit, color: Colors.yellow[800]),
                            const Text(
                              "Editar",
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RequestFormPage(
                                  widget.model,
                                  requestData: widget.request)));
                        }),
                    TextButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          Text(
                            "Excluir",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        RequestReposiroty().deleteRequest(
                            id: widget.request.id!,
                            onSuccess: () => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              "Pedido de auxílio excluído.")))
                                },
                            onFail: (error) => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                          content: Text("$error")))
                                });
                      },
                    )
                  ],
                );
              });
        });
  }
}
