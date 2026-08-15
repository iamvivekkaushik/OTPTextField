import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_text_field/otp_text_field.dart';

Widget buildTestApp({
  int length = 4,
  OtpFieldController? controller,
  List<TextInputFormatter>? inputFormatter,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onCompleted,
}) {
  return MaterialApp(
    home: Scaffold(
      body: OTPTextField(
        length: length,
        width: 300,
        fieldWidth: 40,
        spaceBetween: 4,
        controller: controller,
        inputFormatter: inputFormatter,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        onCompleted: onCompleted,
      ),
    ),
  );
}

void main() {
  Finder fieldAt(int index) => find.byType(TextField).at(index);

  testWidgets('renders one TextField per digit', (tester) async {
    await tester.pumpWidget(buildTestApp(length: 6));
    expect(find.byType(TextField), findsNWidgets(6));
  });

  testWidgets('typing a digit moves focus to the next field', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.enterText(fieldAt(0), '1');
    await tester.pump();

    final secondField = tester.widget<TextField>(fieldAt(1));
    expect(secondField.focusNode!.hasFocus, isTrue);
  });

  testWidgets('calls onChanged and onCompleted correctly', (tester) async {
    String? lastChanged;
    String? completed;

    await tester.pumpWidget(buildTestApp(
      onChanged: (pin) => lastChanged = pin,
      onCompleted: (pin) => completed = pin,
    ));

    await tester.enterText(fieldAt(0), '1');
    await tester.enterText(fieldAt(1), '2');
    await tester.enterText(fieldAt(2), '3');
    await tester.pump();
    expect(lastChanged, '123');
    expect(completed, isNull);

    await tester.enterText(fieldAt(3), '4');
    await tester.pump();
    expect(lastChanged, '1234');
    expect(completed, '1234');
  });

  testWidgets('does not crash when onChanged is not provided',
      (tester) async {
    await tester.pumpWidget(buildTestApp(onCompleted: (_) {}));

    await tester.enterText(fieldAt(0), '1');
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('deleting the first digit clears it from the pin',
      (tester) async {
    String? lastChanged;

    await tester.pumpWidget(buildTestApp(onChanged: (pin) => lastChanged = pin));

    await tester.enterText(fieldAt(0), '1');
    await tester.pump();
    expect(lastChanged, '1');

    await tester.enterText(fieldAt(0), '');
    await tester.pump();
    expect(lastChanged, '');
  });

  testWidgets('typing over an existing digit replaces it', (tester) async {
    String? lastChanged;

    await tester.pumpWidget(buildTestApp(onChanged: (pin) => lastChanged = pin));

    await tester.enterText(fieldAt(0), '1');
    await tester.pump();

    // Simulates typing next to the existing character: the field ends up
    // with '12' and only the newly typed character should be kept.
    await tester.enterText(fieldAt(0), '12');
    await tester.pump();

    expect(tester.widget<TextField>(fieldAt(0)).controller!.text, '2');
    expect(lastChanged, '2');
  });

  testWidgets('pasting distributes digits across fields', (tester) async {
    String? completed;

    await tester.pumpWidget(buildTestApp(onCompleted: (pin) => completed = pin));

    await tester.enterText(fieldAt(0), '1234');
    await tester.pump();

    for (int i = 0; i < 4; i++) {
      expect(tester.widget<TextField>(fieldAt(i)).controller!.text, '${i + 1}');
    }
    expect(completed, '1234');
  });

  testWidgets('pasting longer codes truncates to the field length',
      (tester) async {
    String? completed;

    await tester.pumpWidget(buildTestApp(onCompleted: (pin) => completed = pin));

    await tester.enterText(fieldAt(0), '123456789');
    await tester.pump();

    expect(completed, '1234');
  });

  testWidgets('partial paste clears stale trailing digits', (tester) async {
    String? lastChanged;
    String? completed;

    await tester.pumpWidget(buildTestApp(
      length: 6,
      onChanged: (pin) => lastChanged = pin,
      onCompleted: (pin) => completed = pin,
    ));

    await tester.enterText(fieldAt(0), '123456');
    await tester.pump();
    expect(completed, '123456');

    await tester.enterText(fieldAt(0), '78');
    await tester.pump();

    expect(lastChanged, '78');
    expect(completed, isNull);
    expect(tester.widget<TextField>(fieldAt(5)).controller!.text, '');
  });

  testWidgets('paste respects input formatters', (tester) async {
    String? lastChanged;

    await tester.pumpWidget(buildTestApp(
      inputFormatter: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (pin) => lastChanged = pin,
    ));

    await tester.enterText(fieldAt(0), 'ab12');
    await tester.pump();

    expect(lastChanged, '12');
  });

  testWidgets('OtpFieldController.clear resets all fields', (tester) async {
    final controller = OtpFieldController();
    String? lastChanged;

    await tester.pumpWidget(buildTestApp(
      controller: controller,
      onChanged: (pin) => lastChanged = pin,
    ));

    await tester.enterText(fieldAt(0), '1');
    await tester.enterText(fieldAt(1), '2');
    await tester.pump();

    controller.clear();
    await tester.pump();

    for (int i = 0; i < 4; i++) {
      expect(tester.widget<TextField>(fieldAt(i)).controller!.text, '');
    }
    expect(lastChanged, '');
  });

  testWidgets('OtpFieldController.set fills the fields', (tester) async {
    final controller = OtpFieldController();
    String? completed;

    await tester.pumpWidget(buildTestApp(
      controller: controller,
      onCompleted: (pin) => completed = pin,
    ));

    controller.set(['1', '2', '3', '4']);
    await tester.pump();

    expect(completed, '1234');
  });

  testWidgets('OtpFieldController.set rejects wrong pin length',
      (tester) async {
    final controller = OtpFieldController();
    await tester.pumpWidget(buildTestApp(controller: controller));

    expect(() => controller.set(['1', '2', '3', '4', '5']),
        throwsArgumentError);
    expect(() => controller.set(['1', '2']), throwsArgumentError);
  });

  testWidgets('OtpFieldController.setValue updates a single field',
      (tester) async {
    final controller = OtpFieldController();
    String? lastChanged;

    await tester.pumpWidget(buildTestApp(
      controller: controller,
      onChanged: (pin) => lastChanged = pin,
    ));

    controller.setValue('7', 2);
    await tester.pump();

    expect(tester.widget<TextField>(fieldAt(2)).controller!.text, '7');
    expect(lastChanged, '7');
    expect(() => controller.setValue('1', -1), throwsArgumentError);
    expect(() => controller.setValue('1', 4), throwsArgumentError);
  });

  testWidgets('using a detached controller throws a StateError',
      (tester) async {
    final controller = OtpFieldController();
    expect(() => controller.clear(), throwsStateError);
  });

  testWidgets('controller survives a widget rebuild and detaches on dispose',
      (tester) async {
    final controller = OtpFieldController();
    await tester.pumpWidget(buildTestApp(controller: controller));

    await tester.enterText(fieldAt(0), '1');
    await tester.pump();

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(() => controller.clear(), throwsStateError);
  });
}
