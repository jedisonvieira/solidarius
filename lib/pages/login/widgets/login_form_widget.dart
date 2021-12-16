import 'package:solidarius/pages/signup/signup_page.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/pages/home/home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginFormWidget extends StatefulWidget {
  final UserModel model;

  const LoginFormWidget(this.model, {Key? key}) : super(key: key);

  @override
  _LoginFormWidgetState createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "E-mail"),
                  validator: (email) {
                    if (email!.isEmpty || !email.contains("@")) {
                      return "E-mail inválido";
                    }
                  }),
              TextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Senha",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => {
                      setState(() {
                        _obscureText = !_obscureText;
                      })
                    },
                  ),
                ),
                validator: (senha) {
                  if (senha!.isEmpty) return "Senha inválida";
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: const Text("Esqueci minha senha",
                      textAlign: TextAlign.right),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.model.singIn(
                            onFail: () {},
                            email: _emailController.text,
                            password: _passwordController.text,
                            onSuccess: () {
                              Future.delayed(Duration.zero, () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                              });
                            });
                      }
                    },
                  ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    child: const Text("Criar conta"),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupPage(widget.model)))
                    },
                  ))
                ],
              )
            ],
          )),
    );
  }
}
