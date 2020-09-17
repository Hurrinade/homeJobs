import 'package:flutter/material.dart';
import 'package:homejobs/Screens/loading.dart';
import 'package:homejobs/services/auth.dart';
import 'package:homejobs/models/email_textField.dart';
import 'package:homejobs/services/database.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';

class Register extends StatefulWidget {
  final Function toggle;
  Register({this.toggle});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool load = false;

  //password text field
  Widget passwordTextField(
      BuildContext context, TextEditingController controller) {
    return TextFormField(
      obscureText: true,
      controller: controller,
      validator: (val) => val.length < 8 ? 'Password is to short' : null,
    );
  }

  //register box
  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 15.0),
              blurRadius: 15.0),
          BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -10.0),
              blurRadius: 10.0),
        ]);
  }

  //Form
  Widget _myRegisterForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.blockSizeVertical * 12),
          Container(
            width: double.infinity,
            height: SizeConfig.blockSizeVertical * 60,
            decoration: myBoxDecoration(context),
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 6,
                  right: SizeConfig.blockSizeHorizontal * 7,
                  top: SizeConfig.blockSizeHorizontal * 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 35),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Text('Email'),
                  emailTextField(context, emailController),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Text('Password'),
                  passwordTextField(context, passwordController),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 6,
                  ),
                  Center(
                      child: RaisedButton(
                    child: Text('Register'),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          load = true;
                        });
                        dynamic result = await _auth.registerEmailAndPassword(
                          emailController.text.trimRight(),
                          passwordController.text,
                        );
                        if (result == null) {
                          setState(() {
                            load = false;
                          });
                          print('error registering');
                        }
                        //print(passwordController.text);
                      }
                    },
                  )),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  Center(
                      child: FlatButton(
                          onPressed: () => setState(() => widget.toggle()),
                          child: Text('Login'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return load
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.teal[200],
            body: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[],
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 7,
                        right: SizeConfig.blockSizeHorizontal * 7,
                        top: SizeConfig.blockSizeVertical * 8),
                    child: _myRegisterForm(context),
                  ),
                ),
              ],
            ),
          );
  }
}
