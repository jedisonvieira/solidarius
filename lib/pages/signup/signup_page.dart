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
  UserData _user = UserData();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: _user.avatar == null
                          ? CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              child: ClipOval(
                                child: Icon(
                                  Icons.person,
                                  size: 150,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              child: ClipOval(
                                child: Image(
                                  fit: BoxFit.fitHeight,
                                  image: AssetImage(_user.avatar!),
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
                  _formFieldFactory(
                      controller: _nameController,
                      label: "Nome completo",
                      keyboard: TextInputType.name,
                      isMandatory: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 1,
                          child: _formFieldFactory(
                              controller: _ageController,
                              label: "Idade",
                              keyboard: TextInputType.number,
                              isMandatory: true)),
                      const VerticalDivider(),
                      Flexible(
                        flex: 2,
                        child: _formFieldFactory(
                            controller: _phoneController,
                            label: "Telefone",
                            keyboard: TextInputType.phone,
                            isMandatory: true),
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
                        onPressed: () {
                          _userSignup(context);
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

  void _userSignup(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _user.age = _ageController.text;
      _user.name = _nameController.text;
      _user.phone = _phoneController.text;
      _user.email = _emailController.text;
      widget.model.signUp(
          userData: _user.toMap(_user),
          pass: _passwordController.text,
          onSuccess: () {
            widget.model.singIn(
                email: _user.email!,
                password: _passwordController.text,
                onSuccess: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()))
                    },
                onFail: () => {});
          },
          onFail: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                duration: Duration(seconds: 3),
                backgroundColor: Colors.redAccent,
                content: Text("Erro ao cadastrar usuário")));
          });
    }
  }

  TextFormField _formFieldFactory(
      {required controller,
      required label,
      required TextInputType keyboard,
      required bool isMandatory}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (field) {
        if (isMandatory && field!.trim().isEmpty) {
          return "Campo obrigatório";
        }
      },
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
      _user.avatar = iconPicked;
    });
  }
}
