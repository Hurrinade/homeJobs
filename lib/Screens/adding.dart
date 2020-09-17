import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:homejobs/Screens/loading.dart';
import 'package:homejobs/models/date.dart';
import 'package:homejobs/models/job.dart';
import 'package:homejobs/services/auth.dart';
import 'package:homejobs/services/database.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';
import 'package:intl/intl.dart';

class Adding extends StatefulWidget {
  @override
  AddingState createState() => AddingState();
}

class AddingState extends State<Adding> {
  Color color = Color(0xffff9800);
  Color pickerColor = Color(0xffff9800);
  String name = '';
  String userName = '';
  String date;
  DatabaseService _db = DatabaseService();
  AuthService _auth = AuthService();
  static List<Map> customDate = [];

  List<Map> get custom => customDate;

  Future<List<Dates>> _myTrackerBody(String name) async {
    var docRef = await _db.jobCollection.doc(name).get();
    var data = docRef.data();
    Job date = Job.fromMap(data);

    //return date.dates;
  }

  //adding function
  void _add(BuildContext context, String name, String userName) async {
    final exists = await _db.jobCollection.doc(name).get();
    //List<Map> curr = await _myTrackerBody(name);
    if (exists.exists) {
      return _myAlert();
    } else if (customDate != null) {
      //gets date when we add new job
      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('dd.MM.yyyy').add_jm();
      final String formatted = formatter.format(now);

      Dates dat = Dates(date: formatted, user: userName);
      Map dates = dat.toMap();
      if (customDate.length >= 10) {
        customDate.removeAt(0);
      } else
        customDate.add(dates);

      await _db.updateJob(
          name, formatted, userName, color.toString(), customDate);
      Navigator.pop(context);
    } else
      Loading();
  }

  //alert dialog if there already is that job
  void _myAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Alert"),
            content: new Text("There already is that job"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Center(
                child: FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  //adding box decoration
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

  //color picker block
  void changeColor(Color newColor) {
    setState(() {
      pickerColor = newColor;
    });
  }

  void _myColorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Pick Color"),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Center(
                child: FlatButton(
                  child: const Text("Got it"),
                  onPressed: () {
                    setState(() {
                      color = pickerColor;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget _myAdd(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: SizeConfig.blockSizeVertical * 12.0),
        Container(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 65,
          decoration: myBoxDecoration(context),
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 7,
                right: SizeConfig.blockSizeHorizontal * 7,
                top: SizeConfig.blockSizeHorizontal * 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add new job',
                  style: TextStyle(fontSize: 35.0),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 3),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: color,
                    ),
                    FlatButton(
                      child:
                          Text('Chose color', style: TextStyle(fontSize: 15.0)),
                      onPressed: () {
                        _myColorDialog();
                      },
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
                Text(
                  'Job name',
                  style: TextStyle(fontSize: 15.0),
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 5),
                Text(
                  'Your name',
                  style: TextStyle(fontSize: 15.0),
                ),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 8),
                Center(
                    child: RaisedButton(
                        color: Colors.indigo[200],
                        child: Text('Create'),
                        onPressed: () {
                          //on click we update our database with name, userName, date
                          _add(context, name, userName);
                        })),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.blockSizeHorizontal * 7,
            right: SizeConfig.blockSizeHorizontal * 7,
            top: SizeConfig.blockSizeVertical * 8),
        child: _myAdd(context),
      )),
    );
  }
}
