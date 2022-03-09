import 'package:flutter/material.dart';

class Methods {
  Future<bool> editionPop(BuildContext context, bool isEdited) {
    if (isEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Desacartar alterações?"),
            content: const Text("Se sair as alterações serão perdidas"),
            actions: [
              TextButton(
                  child: const Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  })
            ],
          );
        },
      );
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  Future<bool> actionPop(
      {required BuildContext context,
      required String title,
      required String content,
      required VoidCallback onYesPress}) {
    bool _returnValue = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
                child: const Text("Não"),
                onPressed: () {
                  _returnValue = false;
                  Navigator.pop(context);
                }),
            TextButton(
              child: const Text("Sim"),
              onPressed: () {
                _returnValue = true;
                Navigator.pop(context);
                onYesPress();
              },
            )
          ],
        );
      },
    );

    return Future.value(_returnValue);
  }

  void scaffoldErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        content: Text(message)));
  }
}
