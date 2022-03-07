import 'package:solidarius/shared/widgets/avatar_picker.dart';
import 'package:solidarius/pages/request/request_page.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/shared/datas/user_data.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final UserData user;

  const UserPage(this.user, {Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  UserData _editedUser = UserData();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _editedUser = UserData(
        id: widget.user.id,
        age: widget.user.age,
        name: widget.user.name,
        phone: widget.user.phone,
        email: widget.user.email,
        avatar: widget.user.avatar,
      );

      _ageController.text = _editedUser.age!;
      _nameController.text = _editedUser.name!;
      _phoneController.text = _editedUser.phone!;
      _emailController.text = _editedUser.email!;
    });
  }

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
                      child: _editedUser.avatar == null
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
                  _formFieldFactory(
                      isMandatory: true,
                      label: "Nome completo",
                      controller: _nameController,
                      keyboard: TextInputType.name),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          flex: 1,
                          child: _formFieldFactory(
                              label: "Idade",
                              controller: _ageController,
                              keyboard: TextInputType.number,
                              isMandatory: true)),
                      const VerticalDivider(),
                      Flexible(
                        flex: 2,
                        child: _formFieldFactory(
                            label: "Telefone",
                            controller: _phoneController,
                            keyboard: TextInputType.number,
                            isMandatory: true),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: const Text("Salvar"),
                        onPressed: () {
                          setState(() {
                            _editedUser.name = _nameController.text;
                            _editedUser.age = _ageController.text;
                            _editedUser.email = _emailController.text;
                            _editedUser.phone = _phoneController.text;
                          });

                          _updateUser(context);
                        },
                      ))
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _updateUser(BuildContext context) {
    UserModel().updateUser(UserData().toMap(_editedUser)).then((value) =>
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RequestPage())));
  }

  TextFormField _formFieldFactory(
      {required controller,
      required label,
      required TextInputType keyboard,
      required bool isMandatory}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
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
      _editedUser.avatar = iconPicked;
    });
  }
}
