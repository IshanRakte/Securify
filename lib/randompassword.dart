import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomPassword extends StatefulWidget {
  const RandomPassword({Key? key}) : super(key: key);

  @override
  _RandomPasswordState createState() => _RandomPasswordState();
}

class _RandomPasswordState extends State<RandomPassword> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE7C6),
      appBar: AppBar(
        title: Text('Random Password Generator',
            style: GoogleFonts.getFont('Inter', color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff22577E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              readOnly: true,
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
            ElevatedButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 13.0)),
                    backgroundColor: MaterialStateProperty.all(
                      Color(0xff22577E),
                    )),
                onPressed: () {
                  final password2 = generatePassword();
                  controller.text = password2;
                },
                child: Text("Generate Random Password")),
          ],
        ),
      ),
    );
  }

  String generatePassword() {
    final length = 8;
    final lettersLowercase = 'abcdefghijklmnopqrstuvwqyz';
    final lettersUppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final numbers = '0123456789';
    final special = '@#=+!\$%&?';

    String chars = '';
    chars += '$lettersLowercase$lettersUppercase';
    chars += '$numbers';
    chars += '$special';

    return List.generate(length, (index) {
      final indexRandom = Random.secure().nextInt(chars.length);

      return chars[indexRandom];
    }).join('');
  }
}
