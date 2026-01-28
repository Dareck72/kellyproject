
import 'package:flutter/material.dart';
import 'package:kellyproject/Pages/Myapp.dart';
import 'dart:ui';
void main() {
  runApp( MaterialApp(
    home: Myapp(),
    debugShowCheckedModeBanner: false,
    scrollBehavior: const MaterialScrollBehavior().copyWith(
    dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
  ),
  ));
}



