import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/HomePage.dart';
import 'package:flutter_password_manager/main.dart';
import 'package:flutter_password_manager/widgets/bottomnavbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  late bool canCheckBiometrics;
  bool authenticated = false;

  @override
  void initState() {
    authenticate();
    main();
    super.initState();
    // _checkBiomentrics();
  }

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    var containsEncryptionKey = await secureStorage.containsKey(key: 'key');

    if (!containsEncryptionKey) {
      var key = Hive.generateSecureKey();
      await secureStorage.write(key: 'key', value: base64UrlEncode(key));
    }

    final key = await secureStorage.read(key: 'key');

    var encryptionKey = base64Url.decode(key!);

    print('Encryption key: $encryptionKey');

    await Hive.openBox('password',
        encryptionCipher: HiveAesCipher(encryptionKey));
  }

  Future<void> checkBiomentrics() async {
    bool canCheckBiometrics;
    try {
      var localAuth = LocalAuthentication();
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }

    if (!mounted) return;

    setState(() {
      canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> authenticate() async {
    try {
      var localAuth = LocalAuthentication();
      authenticated = await localAuth.authenticate(
          localizedReason: 'Please authenticate to show your passwords',
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: false);

      if (authenticated) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavBar()));
      } else {
        setState(() {});
      }
    } catch (e) {
      if (e.toString() == "NotAvailable") {
        (context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE7C6),
      appBar: AppBar(
        title: Text('Authentication', style: GoogleFonts.getFont('Inter'),),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff22577E),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fingerprint',
                style: GoogleFonts.getFont('Inter',
                    fontSize: 24, color: Color(0xff22577E))),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(18.0),
              height: 190,
              width: 190,
              decoration: BoxDecoration(
                  color: Color(0xff22577E).withOpacity(0.3),
                  shape: BoxShape.circle),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    color: Color(0xff22577E), shape: BoxShape.circle),
                child: IconButton(
                    color: Colors.white, onPressed: () => authenticate(), icon: Icon(Icons.fingerprint_outlined,  size: 110,),)
              ),
            ),
            SizedBox(height: 20),
            // TextButton(
            //   onPressed: () => Navigator.push(context,
            //       MaterialPageRoute(builder: (_) => AuthenticationPinPage())),
            //   child: Text('Try again PIN',
            //       style: GoogleFonts.getFont('Inter',
            //           fontSize: 18, color: Color(0xff22577E))),
            // ),
            if (!authenticated)
              Text('Oh ! You Need to authenticate to move forward',
                  style: GoogleFonts.getFont('Inter',
                      fontSize: 15, color: Colors.red)),
            TextButton(
              onPressed: () => authenticate(),
              child: Text('Try again Biometrics',
                  style: GoogleFonts.getFont('Inter',
                      fontSize: 18, color: Color(0xff22577E))),
            ),
          ],
        ),
      ),
    );
  }
}
