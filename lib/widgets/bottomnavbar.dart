import 'package:flutter/material.dart';
import 'package:flutter_password_manager/HomePage.dart';
import 'package:flutter_password_manager/passwordstrength.dart';
import 'package:flutter_password_manager/randompassword.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            RandomPassword(),
            PasswordHomePage(),
            PasswordStrength()
          ],
        ),
        bottomNavigationBar: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Color(0xff22577E),
          ),
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xff87CDFF),
            labelStyle: TextStyle(fontSize: 10.0),
            indicator: UnderlineTabIndicator(),
            indicatorColor: Colors.black54,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.password,
                  size: 24.0,
                ),
                text: 'Random Password Generator',
              ),
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 28.0,
                ),
                text: 'Your Passwords',
              ),
              Tab(
                icon: FaIcon(
                  FontAwesomeIcons.dumbbell,
                  size: 24.0,
                ),
                text: 'Password Strength',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
