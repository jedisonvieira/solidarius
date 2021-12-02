import 'package:solidarius/shared/models/user_model.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  final UserModel model;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignupPage(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Senha",
                    ),
                    validator: (senha) {
                      if (senha!.isEmpty) return "Senha inválida";
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      child: const Text("Registrar-se"),
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {}
                      },
                    ))
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
