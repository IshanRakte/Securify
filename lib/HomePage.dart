import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_password_manager/controllers/EncryptService.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_password_manager/iconmapping.dart' as CustomIcons;

class PasswordHomePage extends StatefulWidget {
  @override
  _PasswordHomePageState createState() => _PasswordHomePageState();
}

class _PasswordHomePageState extends State<PasswordHomePage> {
  Box box = Hive.box('password');
  bool longPressed = false;
  final EncryptService _encryptService = EncryptService();
  // bool _secureText = true;
  final servicecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final emailcontroller = TextEditingController();

  // @override
  // void dispose(){
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE7C6),
      appBar: AppBar(
        title: Text('Your Passwords',
            style: GoogleFonts.getFont('Inter', color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff22577E),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box box, _) {
              if (box.values.isEmpty) {
                return Center(
                    child: Text('No Value!',
                        style: GoogleFonts.getFont('Inter',
                            color: Colors.black87)));
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  Map data = box.getAt(index);

                  return Card(
                    color: Color(0xff95D1CC),
                    margin: EdgeInsets.all(
                      10.0,
                    ),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 20.0,
                        ),
                        // tileColor: Color(0xff1c1c1c),
                        leading: CustomIcons.icons[data['type'.trim()]] ??
                            Icon(
                              Icons.lock,
                              size: 32.0,
                              color: Color(0xff323A82),
                            ),
                        title: Text(
                          "${data['type']}",
                          style: TextStyle(
                            fontSize: 22.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "${data['email']}",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            _encryptService.copyToClipboard(
                              data['password'],
                              context,
                            );
                          },
                          icon: Icon(
                            Icons.copy_rounded,
                            size: 36.0,
                          ),
                        ),
                      ),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          closeOnTap: true,
                          caption: 'Delete',
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () => modalAlertDelete(index, data['type']),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Color(0xff22577E),
        onPressed: insertDB,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  void modalAlertDelete(int index, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
            child: Text('Delete $type', style: GoogleFonts.getFont('Inter'))),
        content: Text('Are you sure to delete $type'),
        actions: [
          TextButton(
              child: Text('Yes'),
              onPressed: () async {
                await box.deleteAt(index);
                setState(() {});
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  void insertDB() {
    late String type;
    late String email;
    late String password;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: EdgeInsets.all(15.0),
                child: Form(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          //controller: servicecontroller,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              icon: Icon(FontAwesomeIcons.google),
                              border: OutlineInputBorder(),
                              labelText: 'Service',
                              hintText: 'Google'),
                          style: GoogleFonts.getFont('Inter', fontSize: 18),
                          onChanged: (value) => type = value,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Enter a value!';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          //controller: emailcontroller,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            icon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                            labelText: 'Username/Email/Phone',
                          ),
                          style: GoogleFonts.getFont('Inter', fontSize: 18),
                          onChanged: (value) => email = value,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Enter a value!';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 15.0),
                        TextFormField(
                          //controller: passwordcontroller,
                          textCapitalization: TextCapitalization.sentences,
                          obscureText: true,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.password,
                            ),
                            // suffixIcon: IconButton(
                            //   icon: Icon(Icons.remove_red_eye_outlined),
                            //   onPressed: () {
                            //     setState(() {
                            //       _secureText = !_secureText;
                            //     });
                            //   },
                            // ),
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          style: GoogleFonts.getFont('Inter', fontSize: 18),
                          onChanged: (value) => password = value,
                          validator: (val) {
                            if (val!.trim().isEmpty) {
                              return 'Enter a value!';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 15.0),
                        ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 50.0, vertical: 13.0)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff22577E),)),
                            child: Text('Save',
                                style:
                                    GoogleFonts.getFont('Inter', fontSize: 18)),
                            onPressed: () {
                              // Encrypt
                              password = _encryptService.encrypt(password);
                              // Insert into DB
                              Box box = Hive.box('password');
                              //insert
                              var value = {
                                'type': type,
                                'email': email,
                                'password': password
                              };
                              box.add(value);
                              Navigator.pop(context);
                              setState(() {});
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
