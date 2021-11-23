import 'package:solidarius/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solidarius',
      theme: ThemeData(
        primaryColor: Colors.blue,
        backgroundColor: const Color.fromRGBO(143, 229, 230, 1),
      ),
      home: const LoginPage(),
    );
  }
}
