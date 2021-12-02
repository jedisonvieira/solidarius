import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  static List<String> avatars = [
    "assets/avatars/boy.png",
    "assets/avatars/girl.png",
    "assets/avatars/programmer.png",
    "assets/avatars/white_woman.png",
    "assets/avatars/black_woman.png",
    "assets/avatars/businessman.png",
  ];

  const AvatarPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        for (var avatar in avatars)
          GestureDetector(
            onTap: () => Navigator.pop(context, avatar),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 50,
                child: Image(
                  image: AssetImage(avatar),
                ),
              ),
            ),
          )
      ],
    );
  }
}
