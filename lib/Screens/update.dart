import 'package:flutter/material.dart';
import 'package:homejobs/Screens/adding.dart';
import 'package:homejobs/models/date.dart';
import 'package:homejobs/services/database.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';
import 'package:intl/intl.dart';

class Update extends StatefulWidget {
  final String jobName;
  final String color;
  Update({this.jobName, this.color});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  String date;
  String userName = '';
  DatabaseService _db = DatabaseService();

  //adding function
  void _update(String name, String userName) async {
    //gets date when we click update

    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy').add_jm();
    final String formatted = formatter.format(now);

    Dates dat = Dates(date: formatted, user: userName);

    Map dates = dat.toMap();
    if (AddingState().custom.length >= 10) {
      AddingState().custom.removeAt(0);
    } else
      AddingState().custom.add(dates);

    await _db.updateJob(
      name,
      formatted,
      userName,
      widget.color.toString(),
      AddingState().custom,
    ); //updating job info
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

  //shows adding UI
  Widget _myAdd(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: SizeConfig.blockSizeVertical * 13.0),
        Container(
          width: double.infinity,
          height: SizeConfig.blockSizeVertical * 60,
          decoration: myBoxDecoration(context),
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 6,
                right: SizeConfig.blockSizeHorizontal * 6,
                top: SizeConfig.blockSizeHorizontal * 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Update job',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 6),
                Center(
                    child: Text(
                  '${widget.jobName}',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                )),
                SizedBox(height: SizeConfig.blockSizeVertical * 6),
                Text('Your name'),
                TextField(
                  onChanged: (val) {
                    setState(() {
                      userName = val;
                    });
                  },
                ),
                SizedBox(height: SizeConfig.blockSizeVertical * 6),
                Center(
                    child: RaisedButton(
                        color: Colors.indigo[200],
                        child: Text('Update'),
                        onPressed: () {
                          //on click we update our database with name, userName, and we update tracker
                          Navigator.pop(context);
                          _update(widget.jobName, userName);
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
