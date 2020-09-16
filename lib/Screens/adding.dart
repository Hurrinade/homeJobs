import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:homejobs/services/database.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';
import 'package:intl/intl.dart';

class Adding extends StatefulWidget {
  @override
  _AddingState createState() => _AddingState();
}

class _AddingState extends State<Adding> {
  Color color = Color(0xffff9800);
  Color pickerColor = Color(0xffff9800);
  String name = '';
  String date;
  String userName = '';
  DatabaseService _db = DatabaseService();

  //adding function
  void _add(BuildContext context, String name, String userName) async {
    final exists = await _db.jobCollection.doc(name).get();

    if (exists.exists) {
      return _myAlert();
    } else {
      //gets date when we add new job

      DateTime now = DateTime.now();
      DateFormat formatter = DateFormat('dd.MM.yyyy').add_jm();
      final String formatted = formatter.format(now);
      await _db.updateJob(name, formatted, userName, color.toString());
      Navigator.pop(context);
    }
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
        SizedBox(height: 100.0),
        Container(
          width: double.infinity,
          height: 450,
          decoration: myBoxDecoration(context),
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add new job',
                  style: TextStyle(fontSize: 35.0),
                ),
                SizedBox(height: 20.0),
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
                SizedBox(height: 30.0),
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
                SizedBox(height: 50.0),
                Text('Your name', style: TextStyle(fontSize: 15.0)),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                ),
                SizedBox(height: 50.0),
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
        padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
        child: _myAdd(context),
      )),
    );
  }
}
