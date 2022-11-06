import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:internet_checker/services/shared_prefs.service.dart';

class DialogsService {

  static showOnExitDialog(BuildContext context) {
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
  }

  static showSettingsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        bool disabledWinNotifications = SharedPrefs.isDisabledWinNotifications();
        bool disabledSounds = SharedPrefs.isDisabledSounds();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
          title: const Text('Settings'),

          content: Column(
            children: [
              CheckboxListTile(
                title: Text("Disable windows notifications", style: TextStyle(fontSize: 12),),
                value: disabledWinNotifications,
                onChanged: (newValue) {
                  if (newValue == true) {
                    SharedPrefs.disableWinNotifications();
                  } else {
                    SharedPrefs.enableWinNotifications();
                  }
                  setState(() {
                    disabledWinNotifications = newValue!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
              CheckboxListTile(
                title: Text("Disable sounds", style: TextStyle(fontSize: 12),),
                value: disabledSounds,
                onChanged: (newValue) {
                  if (newValue == true) {
                    SharedPrefs.disableSounds();
                  } else {
                    SharedPrefs.enableSounds();
                  }

                  setState(() {
                    disabledSounds = newValue!;
                  });

                },
                controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
              ),
            ]
          ),


          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
          }
        );


        
      },
    );
  }

}
