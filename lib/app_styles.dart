import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart' hide MenuItem;

class AppStyles {
  static final buttonColors = WindowButtonColors(
    iconNormal: Color.fromARGB(255, 126, 126, 126),
    mouseOver: Color.fromARGB(255, 0, 38, 92),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: Color.fromARGB(255, 126, 126, 126),
    iconMouseDown: const Color(0xFFFFD500)
  );

  static final closeButtonColors = WindowButtonColors(
    mouseOver: const Color(0xFFD32F2F),
    mouseDown: const Color(0xFFB71C1C),
    iconNormal: const Color(0xFF805306),
    iconMouseOver: Colors.white
  );
}

