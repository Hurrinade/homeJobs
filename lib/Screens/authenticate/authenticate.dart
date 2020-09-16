import 'package:flutter/material.dart';
import 'package:homejobs/Screens/authenticate/register.dart';
import 'package:homejobs/Screens/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool change = false;
  void toggle(){
    setState(() {
      change = !change;
    });
  }

  @override
  Widget build(BuildContext context) {
    return change ? Register(toggle: toggle) : SignIn(toggle: toggle);
  }
}