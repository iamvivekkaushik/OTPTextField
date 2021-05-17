import 'package:flutter/material.dart';

class OtpFieldStyle {
  /// The background color for outlined box.
  final Color backgroundColor;

  /// The border color text field.
  final Color borderColor;

  /// The border color of text field when in focus.
  final Color focusBorderColor;

  /// The border color of text field when disabled.
  final Color disabledBorderColor;


  /// The border color of text field when in focus.
  final Color enabledBorderColor;

  /// The border color of text field when disabled.
  final Color errorBorderColor;

  OtpFieldStyle(
      {this.backgroundColor: Colors.transparent,
      this.borderColor: Colors.black26,
      this.focusBorderColor: Colors.blue,
      this.disabledBorderColor: Colors.grey,
      this.enabledBorderColor: Colors.black26,
      this.errorBorderColor: Colors.red});
}
