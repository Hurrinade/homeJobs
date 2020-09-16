import 'package:flutter/material.dart';

class Tracker extends StatefulWidget {
  final String jobNameKey;
  Tracker({this.jobNameKey});

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  Widget _myTrackerBody() {
    return _myTrackerList();
  }

  Widget _myTrackerList() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('Active Jobs'),
      ),
      body: _myTrackerBody(),
    );
  }
}
