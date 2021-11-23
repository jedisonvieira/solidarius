import 'package:flutter/material.dart';
import 'package:solidarius/pages/login/login_page.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Builder(builder: (context) {
            return const UserAccountsDrawerHeader(
              accountName: Text("name"),
              accountEmail: Text("email"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Icon(Icons.person),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://cdn.vox-cdn.com/thumbor/RXhNQI2TTT_eMhhGxky5bf5ZQIE=/0x0:1754x1241/920x613/filters:focal(737x481:1017x761):format(webp)/cdn.vox-cdn.com/uploads/chorus_image/image/68040475/GettyImages_1060748862.0.jpg"),
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
            onTap: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoginPage()))
            },
          )
        ],
      ),
    );
  }
}
