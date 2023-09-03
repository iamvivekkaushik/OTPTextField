<a href="https://github.com/iamvivekkaushik/OTPTextField">
<img align="left" src="https://raw.githubusercontent.com/iamvivekkaushik/OTPTextField/master/screenshot/logo.png" width="400" height="230" /></a>

<p><h2 align="left">OTP Text Field</h2></p>

<h4>A flutter package to create a OTP Text Field widget in your application.</h4>


___


<p><h6>Stay tuned for the latest updates:</h6>
<a href="https://github.com/iamvivekkaushik" >
<img src="https://raw.githubusercontent.com/iamvivekkaushik/OTPTextField/master/screenshot/github.png" width="220" height="40"></a></p>

</br>

[![Pub](https://img.shields.io/pub/v/otp_text_field)](https://pub.dev/packages/otp_text_field)
[![Twitter](https://img.shields.io/badge/Twitter-@iamvivekkaushik-blue.svg?style=flat)](https://twitter.com/iamvivekkaushik)

## 📱Screenshots
<p align="center">
<img src="https://raw.githubusercontent.com/iamvivekkaushik/OTPTextField/master/screenshot/screen.png" width="300"/>
</p>
<br>

## ⚙️ Installation

Import the following package in your dart file

```dart
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
```

## 👨‍💻 Usage

Use the `OTP Text Field` Widget

```dart
OTPTextField(
  length: 5,
  width: MediaQuery.of(context).size.width,
  fieldWidth: 80,
  style: TextStyle(
    fontSize: 17
  ),
  textFieldAlignment: MainAxisAlignment.spaceAround,
  textCapitalization: TextCapitalization.characters,
  fieldStyle: FieldStyle.underline,
  onCompleted: (pin) {
    print("Completed: " + pin);
  },
),
```

For more detail on usage, check out the example provided.


## 🙍🏻‍♂️ Author

* [Vivek Kaushik](http://github.com/iamvivekkaushik/)


## 📄 License

OTP Text Field is released under the MIT license.
See [LICENSE](./LICENSE) for details.
