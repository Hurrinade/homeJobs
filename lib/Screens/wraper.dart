import 'package:flutter/material.dart';
import 'package:homejobs/Screens/authenticate/authenticate.dart';
import 'package:homejobs/Screens/home/home.dart';
import 'package:homejobs/models/my_user.dart';
import 'package:provider/provider.dart';

class Wraper extends StatefulWidget {
  @override
  _WraperState createState() => _WraperState();
}

class _WraperState extends State<Wraper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    return user != null ? Home() : Authenticate();
  }
}