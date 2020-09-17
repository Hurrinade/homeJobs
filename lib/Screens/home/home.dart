import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homejobs/Screens/adding.dart';
import 'package:homejobs/Screens/tracker.dart';
import 'package:homejobs/Screens/update.dart';
import 'package:homejobs/services/auth.dart';
import 'package:homejobs/models/job.dart';
import 'package:homejobs/services/database.dart';
import 'package:homejobs/utils/Sizing/SizeConfig.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();
  DatabaseService _db = DatabaseService();

  void _myUpdateTrackDialog(
      BuildContext context, String jobName, String jobColor) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text("Chose"),
            //content: new Text("There already is that job"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Edit", style: TextStyle(fontSize: 17.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _update(context, jobName, jobColor);
                },
              ),
              FlatButton(
                child: Text("Tracker", style: TextStyle(fontSize: 17.0)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _tracker(context, jobName);
                },
              ),
            ],
          );
        });
  }

  void _add(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Adding()));
  }

  void _tracker(BuildContext context, String jobName) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Tracker(
              jobNameKey: jobName,
            )));
  }

  void _update(BuildContext context, String jobName, String color) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Update(jobName: jobName, color: color)));
  }

  //body of our home screen refreshes data with stream builder which gets stream every time some data is changed in database
  Widget _myBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _db.jobData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _myJobList(context, snapshot.data.docs);
          } else
            return LinearProgressIndicator();
        });
  }

  //list of myCards created on home screen, takes snapshot.data.docs from database(list<map>)
  Widget _myJobList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children: snapshot.map((data) => _myJobCard(context, data)).toList(),
    );
  }

  //job cards on home screen recognizable by it's name, takes data from our list which is DocumentSnapshot(Map), creates own model of job and displays it
  Widget _myJobCard(BuildContext context, DocumentSnapshot data) {
    final job = Job.fromMap(data.data(), reference: data.reference);
    String valueString = job.color
        .split('(0x')[1]
        .split(')')[0]; //unpacking color value from string
    int value = int.parse(valueString, radix: 16);
    Color color = new Color(value);

    return Card(
      color: Colors.red[50],
      key: ValueKey(job.name),
      child: Dismissible(
        background: Container(
          color: Colors.red,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          alignment: AlignmentDirectional.centerEnd,
        ),
        key: ValueKey(job.name),
        direction: DismissDirection.endToStart,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: color,
          ),
          title: Text(
            '${job.name}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
          subtitle: Text('${job.date}'),
          trailing: Text(
            '${job.userName}',
            style: TextStyle(fontSize: 16.0),
          ),
          onTap: () {
            _myUpdateTrackDialog(context, job.name, job.color);
          },
        ),
        onDismissed: (direction) async {
          await _db.jobCollection.doc(job.name).delete();
        },
      ),
    );
  }

  Widget _myDrawer(BuildContext context) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * 50.0,
      child: Drawer(
        child: Container(
          color: Colors.indigo[100],
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: SizeConfig.blockSizeHorizontal * 40.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _add(context);
                    },
                    child: Text(
                      'Add new job',
                      style: TextStyle(fontSize: 17.0),
                    ),
                    color: Colors.orange[100],
                  )),
              SizedBox(
                height: SizeConfig.blockSizeHorizontal * 15.0,
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 40.0,
                child: RaisedButton(
                  onPressed: null,
                  child: Text(
                    'Sign out',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.orange[100],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeHorizontal * 15.0,
              ),
              SizedBox(
                width: SizeConfig.blockSizeHorizontal * 40.0,
                child: RaisedButton(
                  onPressed: () => _auth.userSignOut(),
                  child: Text(
                    'Sign out',
                    style: TextStyle(fontSize: 17.0),
                  ),
                  color: Colors.orange[100],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('Active Jobs'),
      ),
      body: _myBody(context),
      endDrawer: _myDrawer(context),
    );
  }
}
