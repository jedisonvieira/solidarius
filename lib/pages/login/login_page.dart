import 'package:flutter/material.dart';
import 'package:solidarius/pages/login/widgets/login_form_widget.dart';

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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                height: 200,
                width: 350,
                child: Image(
                  image: AssetImage("assets/images/solidarius_front.jpg"),
                ),
              ),
              LoginFormWidget()
            ],
          ),
        ),
      ),
    );
  }
}
