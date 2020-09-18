import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:homejobs/Screens/wraper.dart';
import 'package:homejobs/services/auth.dart';
import 'package:homejobs/models/my_user.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<MyUser>.value(value: AuthService().user),
      ],
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          primaryColor: Colors.blue[900],
        ),
        home: Wraper(),
      ),
    );
  }
}
