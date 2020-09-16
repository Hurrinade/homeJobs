import 'package:flutter/material.dart';
import 'package:homejobs/services/database.dart';
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
    await _db.updateJob(
      name,
      formatted,
      userName,
      widget.color.toString(),
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
                  'Update job',
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: 40.0),
                Center(
                    child: Text(
                  '${widget.jobName}',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 50.0),
                Text('Your name'),
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
