import 'package:flutter/material.dart';
import 'package:solidarius/navbar/navbar.dart';
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
        //appBar: CustomScrollView(),
        drawer: NavBar(widget.model),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Color.fromRGBO(143, 229, 230, 1),
              floating: true,
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color.fromRGBO(143, 229, 230, 1),
                              child: ClipOval(
                                child: Icon(Icons.person),
                              ),
                            ),
                            title: Text("Item $index"),
                            subtitle: const Text("Items subtittle"),
                            trailing: const Text("Trailing"),
                            onTap: () =>
                                {print(widget.model.userData!["name"])},
                          ),
                        ),
                    childCount: 15))
          ],
        ),
      ),
    );
  }
}
