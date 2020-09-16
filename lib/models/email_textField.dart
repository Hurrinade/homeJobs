import 'package:flutter/material.dart';

Widget emailTextField(BuildContext context, TextEditingController controller){
  return TextFormField(
    controller: controller,
    validator: (val) => val.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? 'Incorect email' : null,
  );
}