import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoho_crm_clone/screens/login.dart';

Future logOut(BuildContext context) async{
  SharedPreferences preferencename = await SharedPreferences.getInstance();
  preferencename.remove('name');
  Navigator.popUntil(context, (_) => !Navigator.canPop(context));
  Navigator.pushReplacement(context,
  new MaterialPageRoute(builder: (context) => Login()));
}