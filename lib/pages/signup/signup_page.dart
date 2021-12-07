import 'package:solidarius/pages/login/login_page.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/datas/user_data.dart';
import 'package:flutter/material.dart';
import 'package:solidarius/shared/widgets/avatar_picker.dart';

class SignupPage extends StatefulWidget {
  final UserModel model;

  const SignupPage(this.model, {Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscureText = true;
  bool _obscureTextConfirm = true;
  UserData _editedUser = new UserData();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(40),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: GestureDetector(
                      child: _editedUser.avatar == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: ClipOval(
                                child: Icon(Icons.person, size: 150),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: ClipOval(
                                child: Image(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(_editedUser.avatar!),
                                ),
                              ),
                            ),
                      onTap: () {
                        _showAvatarPickerDialog();
                      },
                    ),
                  ),
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
                      obscureText: _obscureText,
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () => {
                            setState(() {
                              _obscureText = !_obscureText;
                            })
                          },
                        ),
                      ),
                      validator: (senha) {
                        if (senha!.isEmpty ||
                            senha != _confirmPassController.text) {
                          return "Senha inválida";
                        }
                      }),
                  TextFormField(
                    obscureText: _obscureTextConfirm,
                    controller: _confirmPassController,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Confirmar senha",
                      suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirm
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () => {
                                setState(() {
                                  _obscureTextConfirm = !_obscureTextConfirm;
                                })
                              }),
                    ),
                    validator: (senha) {
                      if (senha!.isEmpty || senha != _passwordController.text) {
                        return "Senha inválida";
                      }
                    },
                  ),
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
                            _editedUser.age = _ageController.text;
                            _editedUser.name = _nameController.text;
                            _editedUser.phone = _phoneController.text;
                            _editedUser.email = _emailController.text;
                            widget.model.signUp(
                                userData: _editedUser.toMap(_editedUser),
                                pass: _passwordController.text,
                                onSuccess: () {
                                  widget.model.singIn(
                                      email: _editedUser.email!,
                                      password: _passwordController.text,
                                      onSuccess: () => {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginPage()))
                                          },
                                      onFail: () => {});
                                },
                                onFail: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              "Erro ao cadastrar usuário")));
                                });
                          }
                        },
                      ))
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> _showAvatarPickerDialog() async {
    String iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            'Escolha um avatar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: AvatarPicker(),
        );
      },
    );

    setState(() {
      _editedUser.avatar = iconPicked;
    });
  }
}
