import 'package:solidarius/pages/login/widgets/login_form_widget.dart';
import 'package:solidarius/pages/request/request_page.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ScopedModelDescendant<UserModel>(
          builder: (BuildContext context, child, model) {
        if (model.isUserLogged()) {
          Future.delayed(Duration.zero, () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const RequestPage()),
                (r) => false);
          });
        } else if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (model.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  width: 350,
                  height: 200,
                  child: Image(
                    image: AssetImage("assets/images/login.jpg"),
                  ),
                ),
                LoginFormWidget(model)
              ],
            ),
          );
        }
      }),
    );
  }
}
