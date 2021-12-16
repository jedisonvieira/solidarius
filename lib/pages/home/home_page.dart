import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solidarius/pages/quest/request_page.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:solidarius/navbar/navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: ScopedModelDescendant<UserModel>(
          builder: (BuildContext context, child, model) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  backgroundColor: Theme.of(context).backgroundColor,
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RequestPage(model))),
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
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Card(
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: Theme.of(context)
                                                .backgroundColor,
                                            child: ClipOval(
                                              child: Icon(
                                                Icons.person,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ),
                                          title: Text(snapshot.data.docs[index]
                                              ["requester"]),
                                          subtitle: Text(
                                            snapshot.data.docs[index]
                                                ["description"],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          trailing: const Icon(Icons.edit),
                                          onTap: () => model.isUserLogged(),
                                        ),
                                      ),
                                  childCount: snapshot.data.docs.length))
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
