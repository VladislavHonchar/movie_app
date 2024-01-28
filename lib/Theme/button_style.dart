import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static final ButtonStyle linkButton = ButtonStyle(
      textStyle: MaterialStatePropertyAll(TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      )),
      foregroundColor: MaterialStatePropertyAll(const Color(0xFF01b4e4))
  );
}
