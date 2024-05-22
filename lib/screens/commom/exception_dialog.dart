import 'package:flutter/material.dart';

showExceptionDialog(
  BuildContext context, {
  required String content,
  String title = "Ocorreu um problema!",
}) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_sharp,
                color: Color.fromARGB(255, 148, 0, 0),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 148, 0, 0),
                ),
              ),
            ],
          ),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color.fromARGB(255, 148, 0, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      });
}
