import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// mapping icons from fontawesome brands to Strings to switch for Password Icons

const Map<String, Icon> icons = {
  'Google': Icon(FontAwesomeIcons.google, color: Color(0xffff3e30), size: 32,),
  'Gmail': Icon(FontAwesomeIcons.envelope, color: Color(0xffbb001b),size: 32,),
  'Facebook': Icon(FontAwesomeIcons.facebook, color: Color(0xff3b5998),size: 32,),
  'Instagram': Icon(FontAwesomeIcons.instagram, color: Color(0xffdd2a7b),size: 32,),
  'Twitter': Icon(FontAwesomeIcons.twitter, color: Color(0xff08a0e9),size: 32,),
  'Snapchat': Icon(FontAwesomeIcons.snapchat, color: Color(0xfffffc00),size: 32,),
  'Behance': Icon(FontAwesomeIcons.behance, color: Colors.black,size: 32,),
  'Linkedin': Icon(FontAwesomeIcons.linkedin, color: Color(0xff0077B5),size: 32,),
  'LinkedIn': Icon(FontAwesomeIcons.linkedin, color: Color(0xff0077B5),size: 32,),
  'Discord': Icon(FontAwesomeIcons.discord, color: Color(0xff738ADB),size: 32,),
};