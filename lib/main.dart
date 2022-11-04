// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart' hide MenuItem;
import 'package:audioplayers/audioplayers.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:system_tray/system_tray.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'package:internet_checker/app_consts.dart';
import 'package:internet_checker/components/titlebar.dart';


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
  // final AppWindow _appWindow = AppWindow();
  final SystemTray _systemTray = SystemTray();
  // final Menu _menuMain = Menu();
  // final Menu _menuSimple = Menu();

  // bool _toogleTrayIcon = true;
  // bool _toogleMenu = true;
  bool _isConnected = false;
  bool _isUserNotifiedAboutTray = false;

  @override
  void initState() {
    super.initState();
    initSystemTray();

    // setting the isConnected flag 
    () async {
      bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
      setState(() {
        _isConnected = isConnected;
      });

      // set interval timer that triggers internet-check
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _watchInternetConnection();
      });
    } ();
  }

  void updateIsUserNotifiedAboutTray() {
    print("=============>");
    setState(() {
      _isUserNotifiedAboutTray = true;
    });
  }

  Future<void> _playSound(String soundName) async {
    AudioPlayer().play(AssetSource('audio/$soundName.wav'));
  }

  void _playGoodSound() {
    _playSound('good');
  }

  void _playSadSound() {
    _playSound('bad');
  }

  Future<void> _watchInternetConnection() async {
    bool isConnected = await SimpleConnectionChecker.isConnectedToInternet();
    if (isConnected == _isConnected) { 
      return;
    }   

    if (isConnected) {
      _playGoodSound();

    } else {
      _playSadSound();
    }

    setState(() {
      _isConnected = isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    var squareColor = _isConnected ? Colors.green : Colors.red;
    var label = _isConnected 
        ? 'Internet: ON ⚡️' 
        : 'Internet: OFF 🌚';

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
                  height: 100,
                  width: 100,
                  color: squareColor,
                ),
              );
            },
          ),
          
          Text(
            label,
            style: Theme.of(context).textTheme.headline5,
          ),
        ],
      ),
    ); 
    
    return Scaffold(
        body: WindowBorder(
          color: const Color(0xFF805306),
          width: 1,
          child: Column(
            children: [
              TitleBar(_isUserNotifiedAboutTray, updateIsUserNotifiedAboutTray),
              content,
            ],
          ),
        )
      );
  }


  Future<void> initSystemTray() async {
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
    
}
