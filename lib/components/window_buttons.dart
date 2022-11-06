import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;

import 'package:internet_checker/app_styles.dart';
import 'package:internet_checker/services/dialogs.service.dart';

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
              appWindow.hide();
              return;
            }

            cbFn();
            DialogsService.showOnExitDialog(context);
          },
        ),
      ],
    );
  }
}