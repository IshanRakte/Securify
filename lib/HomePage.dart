import 'package:flutter/material.dart';
import 'package:flutter_password_manager/controllers/EncryptService.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Passwords',
            style: GoogleFonts.getFont('Inter', color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xff6C5DD3),
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
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  Map data = box.getAt(index);

                  return Card(
                     color: Colors.deepPurple[100],
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
                        leading: CustomIcons.icons[data['type']] ??
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

                // Padding(
                //     padding: EdgeInsets.only(bottom: 15.0),
                //     child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 10.0),
                //       height: 65,
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //           color: Color(0xffEFF3FA),
                //           borderRadius: BorderRadius.circular(8.0)),
                //       child: Row(
                //         //mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           // Icon(Icons.lock_outline_rounded,
                //           //     color: Color(0xff323A82), size: 32),
                //           //     SizedBox(width: MediaQuery.of(context).size.width/30 ,),\
                //           CustomIcons.icons[data['type']] ??
                //         Icon(
                //           Icons.lock,
                //           size: 32.0,
                //         ),
                //           Column(
                //             //mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //               SizedBox(height: 11,),
                //             Text('${data["type"]}',
                //                 style: GoogleFonts.getFont('Inter',
                //                     color: Color(0xff323A82), fontSize: 18)),
                //             Text('${data["email"]}',
                //                 style: GoogleFonts.getFont('Inter',
                //                     color: Color(0xff323A82), fontSize: 14)),
                //           ]),
                //           SizedBox(width: MediaQuery.of(context).size.width/3,),
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             children: [
                //             InkWell(
                //                 onTap: () => _encryptService.copyToClipboard(
                //                     data['password'], context),
                //                 child: Icon(
                //                   Icons.copy_rounded,
                //                   color: Color(0xff6C5DD3),
                //                   size: 28,
                //                 )),
                //             SizedBox(width: 15),
                //             InkWell(
                //                 onTap: () =>
                //                     modalAlertDelete(index, data['type']),
                //                 child: Icon(Icons.delete_outline_outlined,
                //                     color: Colors.red, size: 32)),
                //           ])
                //         ],
                //       ),
                //     ));
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Color(0xff6C5DD3),
        onPressed: insertDB,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
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
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
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
                          textCapitalization: TextCapitalization.sentences,
                          obscureText: true,
                          decoration: InputDecoration(
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
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xff6C5DD3))),
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
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
