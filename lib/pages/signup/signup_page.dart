import 'package:solidarius/shared/models/user_model.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  final UserModel model;

  const SignupPage(this.model, {Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration:
                        const InputDecoration(labelText: "Nome completo"),
                    validator: (email) {
                      if (email!.isEmpty) {
                        return "nome inválido";
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                        flex: 1,
                        child: TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration:
                                const InputDecoration(labelText: "Idade"),
                            validator: (email) {
                              if (email!.isEmpty) {
                                return "idade inválida";
                              }
                            })),
                    const VerticalDivider(),
                    Flexible(
                      flex: 2,
                      child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              const InputDecoration(labelText: "Telefone"),
                          validator: (email) {
                            if (email!.isEmpty) {
                              return "telefone inválido";
                            }
                          }),
                    ),
                  ],
                ),
                TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
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
                        if (_formKey.currentState!.validate()) {
                          print(_nameController.text);
                          print(_emailController.text);
                          print(_passwordController.text);
                        }
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
