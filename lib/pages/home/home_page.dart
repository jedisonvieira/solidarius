import 'package:flutter/material.dart';
import 'package:solidarius/navbar/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomScrollView(),
      drawer: const NavBar(),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            floating: true,
            title: Text("Titulo"),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Item $index')),
                  childCount: 20))
        ],
      ),
    );
  }
}
