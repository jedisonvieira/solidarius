import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solidarius/pages/home/home_page.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({Key? key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscureText = true;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
          child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: "E-mail"),
          ),
          TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: "Senha",
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.blue,
                ),
                onPressed: () => {
                  setState(() {
                    _obscureText = !_obscureText;
                  })
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child:
                  const Text("Esqueci minha senha", textAlign: TextAlign.right),
              onPressed: () {},
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                child: const Text("Entrar"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () => {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HomePage()))
                },
              ))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                child: const Text("Criar conta"),
                style: ElevatedButton.styleFrom(primary: Colors.blue),
                onPressed: () => {
                  /*Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HomePage()))*/
                },
              ))
            ],
          )
        ],
      )),
    );
  }
}
