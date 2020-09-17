import 'package:flutter/material.dart';
import 'package:homejobs/Screens/loading.dart';
import 'package:homejobs/services/auth.dart';
import 'package:homejobs/models/email_textField.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn({this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  bool load = false;
  final _myFormKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  //first function called when this class is called
  @override
  void initState() {
    super.initState();
  }

  //closes controller when widget is deleted
  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  //login box decoration
  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Colors.lightBlue[50],
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

  //password text field
  Widget passwordTextField(
      BuildContext context, TextEditingController controller) {
    return TextFormField(
      obscureText: true,
      controller: controller,
    );
  }

  //form
  Widget _mySignInForm(BuildContext context) {
    return Form(
      key: _myFormKey,
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.blockSizeVertical * 12),
          Container(
            //box with login UI
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
                    'Login',
                    style: TextStyle(fontSize: 35, fontFamily: 'Grandstander'),
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Text(
                    'Email',
                    style:
                        TextStyle(fontFamily: 'Grandstander', fontSize: 16.0),
                  ),
                  emailTextField(context, emailController),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Text('Password', style: TextStyle(fontSize: 16.0)),
                  passwordTextField(context, passwordController),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 6,
                  ),
                  Center(
                      child: RaisedButton(
                    color: Colors.lightBlue[100],
                    child: Text('Login'),
                    onPressed: () async {
                      //sign in button
                      if (_myFormKey.currentState.validate()) {
                        setState(() {
                          load = true;
                        });
                        dynamic result = await _auth.signInEmailAndPassword(
                            emailController.text.trimRight(),
                            passwordController.text);
                        if (result == null) {
                          setState(() {
                            load = false;
                          });
                          ErrorHint('Wrong password or email');
                          print('error signing in');
                        }
                        //print(passwordController.text);
                      }
                    },
                  )),
                  SizedBox(height: SizeConfig.blockSizeVertical * 2),
                  Center(
                      child: FlatButton(
                          onPressed: () => setState(() => widget.toggle()),
                          child: Text('Register'))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //main build of a sign in
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return load
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.lightBlue[200],
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
                    child: _mySignInForm(context),
                  ),
                ),
              ],
            ),
          );
  }
}
