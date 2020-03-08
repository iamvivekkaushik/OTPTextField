import 'package:flutter/material.dart';
import 'package:otp_text_field/style.dart';

class OTPTextField extends StatefulWidget {
  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String> onChanged;

  OTPTextField(
      {Key key,
      this.length = 4,
      this.width = 10,
      this.fieldWidth = 30,
      this.style = const TextStyle(),
      this.textFieldAlignment = MainAxisAlignment.spaceBetween,
      this.obscureText = false,
      this.fieldStyle = FieldStyle.underline,
      this.onChanged}): assert(length > 1);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  List<Widget> _textFields;
  String _pin = "";

  @override
  void initState() {
    super.initState();
    _focusNodes = List<FocusNode>(widget.length);
    _textControllers = List<TextEditingController>(widget.length);

    _textFields = List.generate(widget.length, (int i) {
      return buildTextField(context, i);
    });
  }


  @override
  void dispose() {
    _textControllers.forEach(
            (TextEditingController controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Row(
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _textFields,
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int i) {
    if (_focusNodes[i] == null)
      _focusNodes[i] = new FocusNode();

    if (_textControllers[i] == null)
      _textControllers[i] = new TextEditingController();

    return Container(
      width: widget.fieldWidth,
      child: TextField(
        controller: _textControllers[i],
        textAlign: TextAlign.center,
        maxLength: 1,
        style: widget.style,
        focusNode: _focusNodes[i],
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            counterText: "",
            border: widget.fieldStyle == FieldStyle.box
                ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
                : null),
        onChanged: (String str) {
          List list;

          if (_pin.isEmpty)
            list = List(widget.length);
          else
            list = _pin.split('').map((String text) => Text(text)).toList();

          list[i] = str;

          _pin = list.toString();
          print(_pin);
        },
      ),
    );
  }
}
