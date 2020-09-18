import 'package:flutter/material.dart';
import 'package:homejobs/Screens/loading.dart';
import 'package:homejobs/models/date.dart';
import 'package:homejobs/models/job.dart';
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

  Future<List<Dates>> _myTrackerBody(String name) async {
    var docRef = await _db.jobCollection.doc(name).get();
    var data = docRef.data();
    Job date = Job.fromMap(data);
    return date.dates;
  }

  List<Map> convertCustomStepsToMap({List<Dates> dates}) {
    List<Map> dat = [];
    dates.forEach((Dates date) {
      Map mapDate = date.toMap();
      dat.add(mapDate);
    });
    return dat;
  }

  //adding function
  void _update(String name, String userName) async {
    //gets date when we click update
    List<Dates> curr = await _myTrackerBody(name);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy').add_jm();
    final String formatted = formatter.format(now);

    if (curr != null) {
      Dates date = Dates(date: formatted, user: userName);
      curr.add(date);
      List<Map> converted = convertCustomStepsToMap(dates: curr);

      if (converted.length >= 10) {
        converted.removeAt(0);
      }

      await _db.updateJob(
        name,
        formatted,
        userName,
        widget.color.toString(),
        converted,
      );
    } else
      Loading();
    //updating job info
  }

  //adding box decoration
  BoxDecoration myBoxDecoration(BuildContext context) {
    return BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(8.0),
        gradient: LinearGradient(
            colors: [Colors.blue[300], Colors.blue[100]],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.indigo[300], Colors.indigo[100]],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 7,
                right: SizeConfig.blockSizeHorizontal * 7,
                top: SizeConfig.blockSizeVertical * 8,
                bottom: SizeConfig.blockSizeVertical * 19),
            child: _myAdd(context),
          ),
        ),
      ),
    );
  }
}
