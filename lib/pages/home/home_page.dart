import 'package:flutter/material.dart';
import 'package:solidarius/navbar/navbar.dart';
import 'package:solidarius/pages/quest/request_page.dart';
import 'package:solidarius/shared/models/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel model;

  const HomePage(this.model, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Theme.of(context).primaryColor,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RequestPage(widget.model))),
        ),
        drawer: NavBar(widget.model),
        drawerScrimColor: const Color.fromRGBO(0, 0, 0, 0.7),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
              title: Align(
                child: Text(
                  "Solidarius",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                alignment: Alignment.centerRight,
              ),
              backgroundColor: const Color.fromRGBO(143, 229, 230, 1),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              child: ClipOval(
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            title: Text("Item $index"),
                            subtitle: const Text("Items subtittle"),
                            trailing: const Text("Trailing"),
                            onTap: () => _openRequestDetails(),
                          ),
                        ),
                    childCount: 15))
          ],
        ),
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
