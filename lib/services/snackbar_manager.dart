import 'package:flutter/material.dart';


class SnackbarManager {
  static final SnackbarManager _instance = SnackbarManager._internal();
  factory SnackbarManager() => _instance;

  SnackbarManager._internal();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message, {Duration duration = const Duration(seconds: 2)}) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Center(child: Text(message, style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.green,
        duration: duration,
      ),
    );
  }
}