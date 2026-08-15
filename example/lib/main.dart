import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_text_field.dart';

void main() => runApp(const OtpGalleryApp());

class OtpGalleryApp extends StatelessWidget {
  const OtpGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP TextField Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const OtpGalleryPage(),
    );
  }
}

class OtpGalleryPage extends StatelessWidget {
  const OtpGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Clamped: on the very first frame MediaQuery can still report a zero
    // size, which would otherwise produce a negative width.
    final double contentWidth =
        math.max(MediaQuery.of(context).size.width - 32, 0);

    return Scaffold(
      appBar: AppBar(title: const Text('OTP TextField Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OtpShowcase(
            name: '1. Classic Underline',
            description: 'The default look — FieldStyle.underline.',
            length: 5,
            width: contentWidth,
          ),
          OtpShowcase(
            name: '2. Rounded Box',
            description: 'FieldStyle.box with rounded corners and a custom '
                'focus color.',
            length: 5,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            outlineBorderRadius: 16,
            otpFieldStyle: OtpFieldStyle(focusBorderColor: Colors.blue),
          ),
          OtpShowcase(
            name: '3. Sharp Square',
            description: 'Box style with no corner radius and thick borders.',
            length: 4,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            outlineBorderRadius: 0,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            otpFieldStyle: OtpFieldStyle(
              focusBorderColor: Colors.deepPurple,
              enabledBorderColor: Colors.deepPurple.shade100,
            ),
          ),
          OtpShowcase(
            name: '4. SMS Code (6 digits, dense)',
            description: 'Compact 6-digit layout using isDense and tight '
                'content padding.',
            length: 6,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
          ),
          OtpShowcase(
            name: '5. Dark',
            description: 'Dark background with light borders and text.',
            length: 5,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            style: const TextStyle(fontSize: 20, color: Colors.white),
            otpFieldStyle: OtpFieldStyle(
              backgroundColor: Colors.grey.shade900,
              enabledBorderColor: Colors.grey.shade700,
              focusBorderColor: Colors.tealAccent,
            ),
          ),
          OtpShowcase(
            name: '6. Password',
            description: 'Digits hidden with obscureText for sensitive codes.',
            length: 4,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            obscureText: true,
          ),
          OtpShowcase(
            name: '7. Error State',
            description: 'hasError: true switches every border to the '
                'error color.',
            length: 4,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            hasError: true,
          ),
          OtpShowcase(
            name: '8. Disabled',
            description: 'enabled: false with a custom disabled border color.',
            length: 4,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            enabled: false,
            otpFieldStyle: OtpFieldStyle(disabledBorderColor: Colors.orange),
          ),
          OtpShowcase(
            name: '9. Alphanumeric Invite Code',
            description: 'Text keyboard, uppercase characters, no digit '
                'filter.',
            length: 5,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            inputFormatter: [
              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
            ],
          ),
          OtpShowcase(
            name: '10. Controlled',
            description: 'Driven by an OtpFieldController — try the buttons.',
            length: 5,
            width: contentWidth,
            fieldStyle: FieldStyle.box,
            showControllerButtons: true,
          ),
        ],
      ),
    );
  }
}

/// A named demo section: title, description, the OTP field itself, and a
/// live status line fed by onChanged / onCompleted.
class OtpShowcase extends StatefulWidget {
  final String name;
  final String description;
  final int length;
  final double width;
  final FieldStyle fieldStyle;
  final double outlineBorderRadius;
  final TextStyle style;
  final OtpFieldStyle? otpFieldStyle;
  final bool obscureText;
  final bool hasError;
  final bool enabled;
  final bool isDense;
  final EdgeInsets? contentPadding;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatter;
  final bool showControllerButtons;

  const OtpShowcase({
    super.key,
    required this.name,
    required this.description,
    required this.length,
    required this.width,
    this.fieldStyle = FieldStyle.underline,
    this.outlineBorderRadius = 10,
    this.style = const TextStyle(fontSize: 20),
    this.otpFieldStyle,
    this.obscureText = false,
    this.hasError = false,
    this.enabled = true,
    this.isDense = false,
    this.contentPadding,
    this.keyboardType = TextInputType.number,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatter,
    this.showControllerButtons = false,
  });

  @override
  State<OtpShowcase> createState() => _OtpShowcaseState();
}

class _OtpShowcaseState extends State<OtpShowcase> {
  final OtpFieldController _controller = OtpFieldController();
  String _currentPin = '';
  String _completedPin = '';

  @override
  Widget build(BuildContext context) {
    final double fieldWidth =
        math.max((widget.width - (widget.length - 1) * 8) / widget.length, 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.name, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 2),
        Text(widget.description, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 12),
        OTPTextField(
          controller: _controller,
          length: widget.length,
          width: widget.width,
          fieldWidth: fieldWidth,
          spaceBetween: 8,
          fieldStyle: widget.fieldStyle,
          outlineBorderRadius: widget.outlineBorderRadius,
          style: widget.style,
          otpFieldStyle: widget.otpFieldStyle,
          obscureText: widget.obscureText,
          hasError: widget.hasError,
          enabled: widget.enabled,
          isDense: widget.isDense,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          inputFormatter: widget.inputFormatter,
          onChanged: (pin) => setState(() => _currentPin = pin),
          onCompleted: (pin) => setState(() => _completedPin = pin),
        ),
        const SizedBox(height: 8),
        Text(
          _completedPin.isNotEmpty
              ? 'Completed: $_completedPin'
              : 'Current: $_currentPin',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _completedPin.isNotEmpty
                    ? Colors.green.shade700
                    : Colors.grey,
              ),
        ),
        if (widget.showControllerButtons) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setState(() {
                  _completedPin = '';
                  _controller.clear();
                }),
                child: const Text('Clear'),
              ),
              OutlinedButton(
                onPressed: () => _controller.set(['1', '2', '3', '4', '5']),
                child: const Text('Set 12345'),
              ),
              OutlinedButton(
                onPressed: () => _controller.setValue('9', 0),
                child: const Text('Set first = 9'),
              ),
              OutlinedButton(
                onPressed: () => _controller.setFocus(0),
                child: const Text('Focus first'),
              ),
            ],
          ),
        ],
        const Divider(height: 32),
      ],
    );
  }
}
