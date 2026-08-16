import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OTPTextField extends StatefulWidget {
  /// TextField Controller
  final OtpFieldController? controller;

  /// Number of the OTP Fields
  final int length;

  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;

  /// space between the text fields
  final double spaceBetween;

  /// content padding of the text fields
  final EdgeInsets contentPadding;

  /// Manage the type of keyboard that shows up
  final TextInputType keyboardType;

  /// show the error border or not
  final bool hasError;

  final TextCapitalization textCapitalization;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The style to use for the text being edited.
  final double outlineBorderRadius;

  /// Text Field Alignment
  /// default: MainAxisAlignment.spaceBetween [MainAxisAlignment]
  final MainAxisAlignment textFieldAlignment;

  /// Obscure Text if data is sensitive
  final bool obscureText;

  /// Whether to show the cursor and text selection visuals (highlight and
  /// selection handles) in the fields.
  ///
  /// Defaults to false: the focused field is indicated only by its focused
  /// border. The internal selection used so that typing replaces the
  /// focused digit is kept invisible instead.
  final bool showCursor;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  /// space).
  final bool isDense;

  /// Text Field Style
  final OtpFieldStyle? otpFieldStyle;

  /// Text Field Style for field shape.
  /// default FieldStyle.underline [FieldStyle]
  final FieldStyle fieldStyle;

  /// Callback function, called when a change is detected to the pin.
  final ValueChanged<String>? onChanged;

  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  /// Modify the input direction in the OTP fields.
  final TextDirection? textDirection;

  final List<TextInputFormatter>? inputFormatter;

  /// Whether the first field is focused automatically when the widget is
  /// built. Defaults to false.
  final bool autofocus;

  /// Whether the fields are enabled for user interaction. Defaults to true.
  final bool enabled;

  /// Autofill hints applied to the first field.
  ///
  /// Use [AutofillHints.oneTimeCode] to enable SMS code autofill on
  /// iOS and Android.
  final List<String>? autofillHints;

  const OTPTextField({
    Key? key,
    this.length = 4,
    this.width = 10,
    this.controller,
    this.fieldWidth = 30,
    this.spaceBetween = 0,
    this.otpFieldStyle,
    this.hasError = false,
    this.keyboardType = TextInputType.number,
    this.style = const TextStyle(),
    this.outlineBorderRadius = 10,
    this.textCapitalization = TextCapitalization.none,
    this.textFieldAlignment = MainAxisAlignment.spaceBetween,
    this.obscureText = false,
    this.showCursor = false,
    this.fieldStyle = FieldStyle.underline,
    this.onChanged,
    this.textDirection,
    this.inputFormatter,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    this.isDense = false,
    this.onCompleted,
    this.autofocus = false,
    this.enabled = true,
    this.autofillHints,
  })  : assert(length > 1),
        super(key: key);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late OtpFieldStyle _otpFieldStyle;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _textControllers;

  late List<String> _pin;

  @override
  void initState() {
    super.initState();
    _otpFieldStyle = widget.otpFieldStyle ?? OtpFieldStyle();
    _initFields();
    widget.controller?.setOtpTextFieldState(this);
  }

  /// Creates the focus nodes, text controllers and pin storage.
  ///
  /// These are created once here instead of lazily during [build], so the
  /// widget tree is a pure function of state.
  void _initFields() {
    _focusNodes = List.generate(widget.length, (index) {
      final focusNode = FocusNode();
      focusNode.addListener(() => _handleFocusChange(index));
      focusNode.onKeyEvent = (node, event) => _handleKeyEvent(index, event);
      return focusNode;
    });
    _textControllers =
        List.generate(widget.length, (index) => TextEditingController());
    _pin = List.filled(widget.length, '');
  }

  void _disposeFields() {
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    for (final controller in _textControllers) {
      controller.dispose();
    }
  }

  @override
  void didUpdateWidget(covariant OTPTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.otpFieldStyle != widget.otpFieldStyle) {
      _otpFieldStyle = widget.otpFieldStyle ?? OtpFieldStyle();
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.clearOtpTextFieldState(this);
      widget.controller?.setOtpTextFieldState(this);
    }

    if (oldWidget.length != widget.length) {
      _disposeFields();
      _initFields();
    }
  }

  @override
  void dispose() {
    widget.controller?.clearOtpTextFieldState(this);
    _disposeFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Borders are identical for every field, compute them once per build.
    final InputBorder border = _getBorder(_otpFieldStyle.borderColor);
    final InputBorder focusedBorder =
        _getBorder(_otpFieldStyle.focusBorderColor);
    final InputBorder enabledBorder =
        _getBorder(_otpFieldStyle.enabledBorderColor);
    final InputBorder disabledBorder =
        _getBorder(_otpFieldStyle.disabledBorderColor);
    final InputBorder errorBorder = _getBorder(_otpFieldStyle.errorBorderColor);

    return SizedBox(
      width: widget.width,
      child: Row(
        textDirection: widget.textDirection,
        mainAxisAlignment: widget.textFieldAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return _buildTextField(
            context,
            index,
            border: border,
            focusedBorder: focusedBorder,
            enabledBorder: enabledBorder,
            disabledBorder: disabledBorder,
            errorBorder: errorBorder,
          );
        }),
      ),
    );
  }

  InputBorder _getBorder(Color color) {
    final colorOrError =
        widget.hasError ? _otpFieldStyle.errorBorderColor : color;

    return widget.fieldStyle == FieldStyle.box
        ? OutlineInputBorder(
            borderSide: BorderSide(color: colorOrError),
            borderRadius: BorderRadius.circular(widget.outlineBorderRadius),
          )
        : UnderlineInputBorder(borderSide: BorderSide(color: colorOrError));
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget _buildTextField(
    BuildContext context,
    int index, {
    required InputBorder border,
    required InputBorder focusedBorder,
    required InputBorder enabledBorder,
    required InputBorder disabledBorder,
    required InputBorder errorBorder,
  }) {
    final isLast = index == widget.length - 1;

    Widget field = Semantics(
      label: 'Digit ${index + 1} of ${widget.length}',
      child: TextField(
        controller: _textControllers[index],
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textAlign: TextAlign.center,
        style: widget.style,
        showCursor: widget.showCursor,
        inputFormatters: widget.inputFormatter,
        maxLength: 1,
        // Do not let the built-in length enforcement truncate input: a
        // pasted OTP must reach onChanged intact so it can be
        // distributed across the fields by _handlePaste. Multi-digit
        // values are handled in _onFieldChanged instead.
        maxLengthEnforcement: MaxLengthEnforcement.none,
        focusNode: _focusNodes[index],
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        autofocus: widget.autofocus && index == 0,
        autofillHints: index == 0 ? widget.autofillHints : null,
        decoration: InputDecoration(
          isDense: widget.isDense,
          filled: true,
          fillColor: _otpFieldStyle.backgroundColor,
          counterText: "",
          contentPadding: widget.contentPadding,
          border: border,
          focusedBorder: focusedBorder,
          enabledBorder: enabledBorder,
          disabledBorder: disabledBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
          errorText: null,
          // to hide the error text
          errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (String value) => _onFieldChanged(index, value),
      ),
    );

    if (!widget.showCursor) {
      // Hide the selection highlight and handles, so focus is indicated
      // only by the field's focused border. The selection itself stays
      // functional (typing replaces the focused digit, paste still works).
      final TextSelectionThemeData selectionTheme =
          Theme.of(context).textSelectionTheme;
      field = Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: selectionTheme.copyWith(
            selectionColor: Colors.transparent,
            selectionHandleColor: Colors.transparent,
          ),
        ),
        child: field,
      );
    }

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0 : widget.spaceBetween,
      ),
      child: field,
    );
  }

  void _onFieldChanged(int index, String value) {
    if (value.length > 1) {
      final String oldValue = _pin[index];
      if (oldValue.isNotEmpty &&
          value.startsWith(oldValue) &&
          value.length == oldValue.length + 1) {
        // The user typed a character next to the existing one instead of
        // replacing it - keep only the newly typed character.
        final String newChar = value.substring(value.length - 1);
        _textControllers[index].value = TextEditingValue(
          text: newChar,
          selection: TextSelection.collapsed(offset: newChar.length),
        );
        _onDigitEntered(index, newChar);
      } else {
        // Multiple characters were inserted at once (paste or autofill).
        _handlePaste(value);
      }
      return;
    }

    if (value.isEmpty) {
      _onDigitCleared(index);
    } else {
      _onDigitEntered(index, value);
    }
  }

  void _onDigitEntered(int index, String digit) {
    setState(() {
      _pin[index] = digit;
    });

    // Move focus to the next field, or dismiss the keyboard on the last one.
    if (index + 1 < widget.length) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else {
      _focusNodes[index].unfocus();
    }

    _notifyPinChanged();
  }

  void _onDigitCleared(int index) {
    // Always update the pin first, so deleting the first digit does not
    // leave a stale value behind.
    setState(() {
      _pin[index] = '';
    });

    // Move focus to the previous text field.
    if (index > 0) {
      _focusNodes[index].unfocus();
      _focusNodes[index - 1].requestFocus();
    }

    _notifyPinChanged();
  }

  /// Moves focus to the previous field when backspace is pressed on an
  /// already-empty field.
  ///
  /// A [TextField] does not call [TextField.onChanged] when deleting from
  /// an empty field, so without this the focus would get stuck on the
  /// empty box instead of jumping back.
  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    final bool isBackspace = event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace;

    if (!isBackspace ||
        index == 0 ||
        _textControllers[index].text.isNotEmpty) {
      // Not a backspace, the first field, or a field with content: let the
      // normal editing flow (and _onDigitCleared) handle it.
      return KeyEventResult.ignored;
    }

    _focusNodes[index - 1].requestFocus();
    return KeyEventResult.handled;
  }

  void _handleFocusChange(int index) {
    final TextEditingController controller = _textControllers[index];

    if (_focusNodes[index].hasFocus && controller.text.isNotEmpty) {
      // Select the existing digit so typing replaces it instead of
      // appending next to it.
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }
  }

  String _getCurrentPin() {
    return _pin.join();
  }

  /// Calls [OTPTextField.onChanged] with the current pin, and
  /// [OTPTextField.onCompleted] once every field is filled.
  void _notifyPinChanged() {
    final String currentPin = _getCurrentPin();

    widget.onChanged?.call(currentPin);

    // if there are no empty values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains('') && currentPin.length == widget.length) {
      widget.onCompleted?.call(currentPin);
    }
  }

  void _handlePaste(String value) {
    // Run the pasted text through the same input formatters used while
    // typing, so invalid characters are filtered out.
    String filtered = value;
    final formatters = widget.inputFormatter;
    if (formatters != null) {
      for (final formatter in formatters) {
        filtered = formatter
            .formatEditUpdate(
                TextEditingValue.empty, TextEditingValue(text: filtered))
            .text;
      }
    }

    final int count =
        filtered.length > widget.length ? widget.length : filtered.length;

    setState(() {
      // Fields beyond the pasted text are cleared, so a partial paste never
      // mixes with stale digits left over from a previous entry.
      for (int i = 0; i < widget.length; i++) {
        final String digit = i < count ? filtered[i] : '';
        _textControllers[i].value = TextEditingValue(
          text: digit,
          selection: TextSelection.collapsed(offset: digit.length),
        );
        _pin[i] = digit;
      }
    });

    if (count >= widget.length) {
      // Full code pasted - dismiss the keyboard.
      _focusNodes[widget.length - 1].unfocus();
    } else {
      // Focus the first empty field and let the user continue typing.
      FocusScope.of(context).requestFocus(_focusNodes[count]);
    }

    _notifyPinChanged();
  }

  /// State helpers used by [OtpFieldController].

  void _clearPin() {
    setState(() {
      for (int i = 0; i < _pin.length; i++) {
        _pin[i] = '';
        _textControllers[i].value = TextEditingValue.empty;
      }
    });
  }

  void _setPin(List<String> pin) {
    setState(() {
      for (int i = 0; i < _pin.length; i++) {
        _pin[i] = pin[i];
        _textControllers[i].value = TextEditingValue(
          text: pin[i],
          selection: TextSelection.collapsed(offset: pin[i].length),
        );
      }
    });
  }

  void _setPinValue(int position, String value) {
    setState(() {
      _pin[position] = value;
      _textControllers[position].value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    });
  }
}

class OtpFieldController {
  _OTPTextFieldState? _otpTextFieldState;

  /// Called by [OTPTextField] when it attaches to this controller.
  void setOtpTextFieldState(_OTPTextFieldState state) {
    _otpTextFieldState = state;
  }

  /// Called by [OTPTextField] when it detaches from this controller.
  void clearOtpTextFieldState(_OTPTextFieldState state) {
    if (identical(_otpTextFieldState, state)) {
      _otpTextFieldState = null;
    }
  }

  _OTPTextFieldState get _state {
    final state = _otpTextFieldState;
    if (state == null || !state.mounted) {
      throw StateError(
          'OtpFieldController is not attached to an OTPTextField. '
          'Pass the controller to a OTPTextField before calling its methods.');
    }
    return state;
  }

  void clear() {
    final state = _state;

    state._clearPin();

    state._focusNodes.first.requestFocus();

    state.widget.onChanged?.call('');
  }

  void set(List<String> pin) {
    final state = _state;
    final textFieldLength = state.widget.length;

    if (pin.length != textFieldLength) {
      throw ArgumentError(
          "Pin length must be same as field length. Expected: $textFieldLength, Found ${pin.length}");
    }

    state._setPin(pin);

    final String newPin = pin.join();

    state.widget.onChanged?.call(newPin);

    if (!pin.contains('')) {
      state.widget.onCompleted?.call(newPin);
    }
  }

  void setValue(String value, int position) {
    final state = _state;
    _checkPosition(state, position);

    state._setPinValue(position, value);

    state.widget.onChanged?.call(state._getCurrentPin());
  }

  void setFocus(int position) {
    final state = _state;
    _checkPosition(state, position);

    state._focusNodes[position].requestFocus();
  }

  void _checkPosition(_OTPTextFieldState state, int position) {
    final maxIndex = state.widget.length - 1;
    if (position < 0 || position > maxIndex) {
      throw ArgumentError(
          "Provided position is out of bounds for the OtpTextField");
    }
  }
}
