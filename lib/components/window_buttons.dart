import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;

import 'package:internet_checker/app_styles.dart';

class WindowButtons extends StatelessWidget {
  final bool isUserNotifiedAboutTray;
  final Function cbFn;

  WindowButtons(
    this.isUserNotifiedAboutTray,
    this.cbFn
  );


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: AppStyles.buttonColors),
        MaximizeWindowButton(colors: AppStyles.buttonColors),
        CloseWindowButton(
          colors: AppStyles.closeButtonColors,
          onPressed: () {
            if (isUserNotifiedAboutTray) {
              Navigator.of(context).pop();
              appWindow.hide();
              return;
            }

            // cbFn();

            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Exit Program?'),
                  content: const Text(
                      ('The window will be hidden, to exit the program you can use the system menu.')),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        appWindow.hide();
                      },
                    ),
                  ],
                );
              },
            );

          },
        ),
      ],
    );
  }
}