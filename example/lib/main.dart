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
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        /*child: OTPTextField(
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
          },
        ),*/
        child: OTPTextField(
          length: 4,
          fieldWidth: 50,
          style: TextStyle(color: Colors.white),
          margin: EdgeInsets.zero,
          fieldStyle: FieldStyle.box,
          otpFieldStyle: OtpFieldStyle(
            backgroundColor: Colors.black,
            borderColor: Colors.transparent,
          ),
          textFieldAlignment: MainAxisAlignment.spaceEvenly,
          width: MediaQuery.of(context).size.width,
          onChanged: (pin) {
            print(pin);
          },
          onCompleted: (pin) {
            print(pin);
          },
        ),
      ),
    );
  }
}
