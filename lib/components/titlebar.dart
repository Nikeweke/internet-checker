import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;

import 'package:internet_checker/app_colors.dart';
import 'package:internet_checker/app_consts.dart';
import 'package:internet_checker/components/window_buttons.dart';

class TitleBar extends StatelessWidget {
  final bool isUserNotifiedAboutTray;
  final Function cbFn;

  TitleBar(
    this.isUserNotifiedAboutTray,
    this.cbFn
  );

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.backgroundStartColor, AppColors.backgroundEndColor],
              stops: [0.0, 1.0]),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(5), 
              child: Text(
                AppConstants.appName, 
                style: TextStyle(
                  color: Colors.white70
                )
              ),
            ),

            Expanded(
              child: MoveWindow(),
            ),
            WindowButtons(isUserNotifiedAboutTray, cbFn)
          ],
        ),
      ),
    );
  }
}


