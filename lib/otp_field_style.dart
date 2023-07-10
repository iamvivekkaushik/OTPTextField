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

  OtpFieldStyle({
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.black26,
    this.focusBorderColor = Colors.blue,
    this.disabledBorderColor = Colors.grey,
    this.enabledBorderColor = Colors.black26,
    this.errorBorderColor = Colors.red,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OtpFieldStyle &&
          runtimeType == other.runtimeType &&
          backgroundColor == other.backgroundColor &&
          borderColor == other.borderColor &&
          focusBorderColor == other.focusBorderColor &&
          disabledBorderColor == other.disabledBorderColor &&
          enabledBorderColor == other.enabledBorderColor &&
          errorBorderColor == other.errorBorderColor;

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      borderColor.hashCode ^
      focusBorderColor.hashCode ^
      disabledBorderColor.hashCode ^
      enabledBorderColor.hashCode ^
      errorBorderColor.hashCode;

  @override
  String toString() {
    return 'OtpFieldStyle{backgroundColor: $backgroundColor, borderColor: $borderColor, focusBorderColor: $focusBorderColor, disabledBorderColor: $disabledBorderColor, enabledBorderColor: $enabledBorderColor, errorBorderColor: $errorBorderColor}';
  }
}
