import 'package:solidarius/pages/quest/request_page.dart';
import 'package:solidarius/shared/datas/user_data.dart';
import 'package:solidarius/shared/models/user_model.dart';
import 'package:solidarius/pages/login/login_page.dart';
import 'package:solidarius/pages/user/user_page.dart';
import 'package:flutter/material.dart';

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
                widget.model.userData!["name"] ?? "",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(
                widget.model.userData!["email"] ?? "",
                style: const TextStyle(color: Colors.black),
              ),
              currentAccountPictureSize: const Size.fromRadius(40),
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
                  : CircleAvatar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/images/drawer.jpg"),
                      fit: BoxFit.cover)),
            );
          }),
          Visibility(
            visible: !widget.model.isUserLogged(),
            child: ListTile(
              leading: const Icon(
                Icons.login,
                color: Colors.blue,
              ),
              title: const Text(
                "Entre ou cadastre-se",
                style: TextStyle(color: Colors.blue),
              ),
              onTap: () => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginPage()))
              },
            ),
          ),
          const Divider(),
          Visibility(
            visible: widget.model.isUserLogged(),
            child: ListTile(
              title: const Text("Meu perfil"),
              leading:
                  Icon(Icons.person, color: Theme.of(context).primaryColor),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        UserPage(UserData.fromMap(widget.model.userData))))
              },
            ),
          ),
          ListTile(
            leading:
                Icon(Icons.emoji_people, color: Theme.of(context).primaryColor),
            title: const Text("Pedidos de auxílio"),
            onTap: () => {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RequestPage()))
            },
          ),
          const Divider(),
          Visibility(
            visible: widget.model.isUserLogged(),
            child: ListTile(
              title: const Text("Sair"),
              leading:
                  Icon(Icons.logout, color: Theme.of(context).primaryColor),
              onTap: () async {
                await widget.model.logOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
