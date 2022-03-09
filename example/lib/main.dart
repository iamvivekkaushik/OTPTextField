import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Awesome Credit Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Awesome Credit Card Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.cleaning_services),
        onPressed: () {
          print("Floating button was pressed.");
          otpController.set(['2', '3', '5', '5', '7']);
          //otpController.clear();
          // otpController.set(['2', '3', '5', '5', '7']);
          // otpController.setValue('3', 0);
          // otpController.setFocus(1);
        },
      ),
      body: Center(
        child: OTPTextField(
            controller: otpController,
            length: 5,
            width: MediaQuery.of(context).size.width,
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldWidth: 55,
            fieldStyle: FieldStyle.box,
            outlineBorderRadius: 15,
            style: TextStyle(fontSize: 17),
            onChanged: (pin) {
              print("Changed: " + pin);
            },
            onCompleted: (pin) {
              print("Completed: " + pin);
              otpController.setFocus(4);
            }),
      ),
    );
  }
}
