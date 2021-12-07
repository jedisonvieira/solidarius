import 'package:flutter/material.dart';
import 'package:solidarius/pages/login/login_page.dart';
import 'package:solidarius/shared/models/user_model.dart';

class NavBar extends StatefulWidget {
  final UserModel model;

  const NavBar(this.model, {Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (context) {
            return UserAccountsDrawerHeader(
              accountName: Text(
                widget.model.userData!["name"],
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                widget.model.userData!["email"],
                style: const TextStyle(color: Colors.black),
              ),
              currentAccountPicture: widget.model.userData!["avatar"] != null
                  ? CircleAvatar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: ClipOval(
                        child: Image(
                          fit: BoxFit.fitHeight,
                          image: AssetImage(widget.model.userData!["avatar"]),
                        ),
                      ),
                    )
                  : const CircleAvatar(
                      child: ClipOval(
                        child: Icon(Icons.person),
                      ),
                    ),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/images/drawer.jpg"),
                      fit: BoxFit.cover)),
            );
          }),
          ListTile(
            leading: const Icon(Icons.ac_unit_rounded),
            title: const Text("Primeiro menu"),
            onTap: () => {print("teste")},
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_rounded),
            title: const Text("Segundo menu"),
            onTap: () => {print("teste")},
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_rounded),
            title: const Text("Terceiro menu"),
            onTap: () => {print("teste")},
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_rounded),
            title: const Text("Quarto menu"),
            onTap: () => {print("teste")},
          ),
          ListTile(
            leading: const Icon(Icons.ac_unit_rounded),
            title: const Text("Quinto menu"),
            onTap: () => {print("teste")},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
            onTap: () async {
              await widget.model.logOut();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
          )
        ],
      ),
    );
  }
}
