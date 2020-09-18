import 'package:flutter/material.dart';
import 'package:homejobs/Screens/loading.dart';
import 'package:homejobs/models/date.dart';
import 'package:homejobs/models/job.dart';
import 'package:homejobs/services/database.dart';

class Tracker extends StatefulWidget {
  final String jobNameKey;
  Tracker({this.jobNameKey});

  @override
  _TrackerState createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {
  DatabaseService _db = DatabaseService();
  int size;

  Future<List<Dates>> _myTrackerBody() async {
    var docRef = await _db.jobCollection.doc(widget.jobNameKey).get();
    var data = docRef.data();
    Job date = Job.fromMap(data);
    size = date.dates.length;

    return date.dates;
  }

  Widget _myTrackCard(BuildContext context, Dates date) {
    return Card(
      key: ValueKey(widget.jobNameKey),
      child: ListTile(
        title: Text('${date.date}'),
        subtitle: Text('${date.user}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text('Active Jobs'),
      ),
      body: Container(
        child: FutureBuilder(
            future: _myTrackerBody(),
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Loading()
                  : ListView.builder(
                      itemCount: size,
                      itemBuilder: (BuildContext context, int index) {
                        return _myTrackCard(context, snapshot.data[index]);
                      },
                    );
            }),
      ),
    );
  }
}
