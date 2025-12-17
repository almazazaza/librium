import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'package:librium/core/constants/app_theme.dart';
import '../utils/url_launcher.dart';


class LinkedTextSpan extends TextSpan {
  LinkedTextSpan({
    required String text,
    required String url,
    Color? color,
    double fontSize = 14,
    TextDecoration decoration = TextDecoration.underline,
  }) : super (
    text: text,
      style: TextStyle(
        color: color ?? AppTheme().themeData.colorScheme.primary,
        fontSize: fontSize,
        decoration: decoration,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchURL(url);
        },
  );
}
class EmailTextSpan extends TextSpan {
  EmailTextSpan({
    required String text,
    required String email,
    Color? color,
    double fontSize = 14,
    TextDecoration decoration = TextDecoration.underline,
  }) : super (
    text: text,
      style: TextStyle(
        color: color ?? AppTheme().themeData.colorScheme.primary,
        fontSize: fontSize,
        decoration: decoration,
      ),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launchEmail(email);
        },
  );
}