import 'package:scoped_model/scoped_model.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/pages/login/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
          title: 'Solidarius',
          theme: ThemeData(
            primaryColor: Colors.blue,
            backgroundColor: const Color.fromRGBO(143, 229, 230, 1),
          ),
          home: LoginPage(),
        ));
  }
}
