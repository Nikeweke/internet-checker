// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:win_toast/win_toast.dart';

import 'package:internet_checker/app_consts.dart';
import 'package:internet_checker/components/titlebar.dart';
import 'package:internet_checker/services/sound.service.dart';
import 'package:internet_checker/services/date.service.dart';


class JournalRecord {
  JournalRecord(this.connectionState, this.text);
  bool connectionState = false;
  String text = '';
} 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(
      AppConstants.windowWidth, 
      AppConstants.windowHeight
    );
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = AppConstants.appName;
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Internet checker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer _timer;
  final SystemTray _systemTray = SystemTray();

  bool _isConnected = true;
  bool _isUserNotifiedAboutTray = false;
  final _journal = <JournalRecord>[]; // journal of connection changes

  @override
  void initState() {
    super.initState();
    _initSystemTray();
    _initWindowsToasts();

    // set interval timer that triggers internet-check
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      _watchInternetConnection();
    });
  }

  void updateIsUserNotifiedAboutTray() {
    setState(() {
      _isUserNotifiedAboutTray = true;
    });
  }

  Future<void> _watchInternetConnection() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();

    if (isConnected == _isConnected) { 
      return;
    }   
    if (_journal.isNotEmpty) {
      var firstRecord = _journal[0];
      if (firstRecord.connectionState == isConnected) {
        return;
      }
    }

    if (isConnected) {
      SoundService.playGoodSound();
    } else {
      SoundService.playSadSound();
    }

    var time = DateService.getJournalDateNow();
    var connectionStateWord = isConnected ? 'ON' : 'OFF';
    var logMessage = "($time) Connection: $connectionStateWord";
    var toastMessage = "Connection was changed - $connectionStateWord";

    _journal.insert(0, JournalRecord(isConnected, logMessage));

    if (_journal.length > 5) {
      _journal.removeLast();
    }
      
    await WinToast.instance().showToast(
      type: ToastType.text01, 
      title: toastMessage,
    );

    setState(() {
      _isConnected = isConnected;
    });
  }

  Future<void> _initWindowsToasts() async {
    await WinToast.instance().initialize(
      appName: AppConstants.appName,
      productName: AppConstants.appName,
      companyName: AppConstants.appName,
    );
  }

  Future<void> _initSystemTray() async {
    String path = Platform.isWindows 
      ? 'assets/app_icon.ico' 
      : 'assets/app_icon.png';

    // We first init the systray menu
    await _systemTray.initSystemTray(
      title: "system tray",
      iconPath: path,
    );

    // create context menu
    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => appWindow.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => appWindow.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => appWindow.close()),
    ]);

    // set context menu
    await _systemTray.setContextMenu(menu);

    // handle system tray event
    _systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? appWindow.show() : _systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? _systemTray.popUpContextMenu() : appWindow.show();
      }
    });
  }
    
  Widget _buildJournalList() {
    var list = ListView.separated(
      // reverse: true,
      padding: const EdgeInsets.all(20.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: _journal.length,
      itemBuilder: (context, index) {
        var item = _journal[index];
        return Text(item.text, style: TextStyle(fontSize: 13));
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );

    var container = Container(
      // margin: const EdgeInsets.all(15.0),
      // padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400)
      ),
      child: list,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 35.0,
        maxHeight: 160.0,
      ),
      child: container,
    );
  }

  @override
  Widget build(BuildContext context) {
    var squareColor = Colors.green;
    var label = 'Internet: ON ⚡️';

    if (!_isConnected) {
      squareColor = Colors.red;
      label = 'Internet: OFF 🌚';
    } 

    var content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          LayoutBuilder(
            builder: (context, constraints) {
              // final size = min(constraints.maxWidth, constraints.maxHeight);
              return Align(
                alignment: Alignment.center,
                child: Container(
                  height: 50,
                  width: 50,
                  color: squareColor,
                ),
              );
            },
          ),
          
          Text(
            label,
            style: Theme.of(context).textTheme.headline5,
          ),

          SizedBox(height: 20),

          _buildJournalList(),

          // LayoutBuilder(
          //   builder: (context, constraints) {
          //     return Align(
          //       alignment: Alignment.center,
          //       child: _buildJournalList(),
          //     );
          //   },
          // ),
        ],
      ),
    ); 
    
    return Scaffold(
        body: Column(
            children: [
              TitleBar(_isUserNotifiedAboutTray, updateIsUserNotifiedAboutTray),
              content,
            ],
          ),
    );
  }
}
