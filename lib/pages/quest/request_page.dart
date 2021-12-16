import 'package:solidarius/pages/quest/widgets/request_card.dart';
import 'package:solidarius/pages/quest/widgets/request_form_page.dart';
import 'package:solidarius/shared/datas/request_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:solidarius/navbar/navbar.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: ScopedModelDescendant<UserModel>(
          builder: (BuildContext context, child, model) {
            model.isUserLogged();
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestFormPage(model))),
                ),
                drawer: NavBar(model),
                drawerScrimColor: const Color.fromRGBO(0, 0, 0, 0.7),
                body: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("requests")
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            floating: true,
                            iconTheme: IconThemeData(
                                color: Theme.of(context).primaryColor),
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Solidarius",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            backgroundColor:
                                const Color.fromRGBO(143, 229, 230, 1),
                          ),
                          SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                            return RequestCard(
                                model,
                                RequestData.fromDocument(
                                    snapshot.data.docs[index]));
                          }, childCount: snapshot.data.docs.length))
                        ],
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ));
          },
        ));
  }
}
