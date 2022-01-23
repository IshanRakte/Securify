import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:password_strength/password_strength.dart';

class PasswordStrength extends StatefulWidget {


  @override
  _PasswordStrengthState createState() => _PasswordStrengthState();
}

class _PasswordStrengthState extends State<PasswordStrength> {
  final controller = TextEditingController();

  // late String inputpassword;
  double strength = 0;
  late String _password;
  String _displayText = 'Please Enter a Password';

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");
  RegExp special = RegExp(r".*@#=+!\$%&?.*");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE7C6),
      appBar: AppBar(
        title: Text('Password Strength Meter',
            style: GoogleFonts.getFont('Inter', color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff22577E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => _checkpassword(value),
              decoration: InputDecoration(
                icon: Icon(
                  Icons.password,
                ),
                border: OutlineInputBorder(),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: () {
                    final data = ClipboardData(text: controller.text);
                    Clipboard.setData(data);

                    final snackBar = SnackBar(
                        backgroundColor: Color(0xff95D1CC),
                        content: Text(
                          "Password Copied",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ));

                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  },
                ),
              ),
              controller: controller,
            ),
            SizedBox(
              height: 50,
            ),
            //  ElevatedButton(
            //     style: ButtonStyle(
            //         padding: MaterialStateProperty.all(
            //             EdgeInsets.symmetric(horizontal: 50.0, vertical: 13.0)),
            //         backgroundColor: MaterialStateProperty.all(
            //           Color(0xff22577E),
            //         )),
            //     onPressed: () {
            //       checkpassword(inputpassword);
            //     },
            //     child: Text("Generate Random Password")),
            //  Text(_result == null ? "" : "${passstrength.toString()}"),
            //  Text('$passstrength')
            LinearProgressIndicator(
              value: strength,
              backgroundColor: Color(0xffEAE7C6),
              color: strength == 1 / 4
                  ? Colors.red
                  : strength == 2 / 4
                      ? Colors.yellow
                      : strength == 3 / 4
                          ? Colors.blue
                          : Colors.green,
              minHeight: 15,
            ),
            SizedBox(height: 40,),
            Text("$_displayText")
          ],
        ),
      ),
    );
  }

  void _checkpassword(String value) {
    print("$strength");
    // strength = estimatePasswordStrength(_password);
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _displayText = 'Plese enter your Password';
      });
    } else if (_password.length < 6) {
      setState(() {
        strength = 1 / 4;
        // _displayText = 'Your Password is too short!';
      });
    } else if (_password.length < 8) {
      setState(() {
        strength = 2 / 4;
        // _displayText = 'Your password is acceptable';
      });
    } else if (_password.length <= 10 ||
        !letterReg.hasMatch(_password) ||
        !numReg.hasMatch(_password)) {
      strength = 3 / 4;

      if (strength == 3 / 4) {
        // _displayText = 'This passsword is strong';
      }
    } else {
      strength = 1;
      // _displayText = "This password is very strong!";
    }
  }
}
