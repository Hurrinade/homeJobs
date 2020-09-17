import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:homejobs/models/date.dart';

class Job {
  String name;
  String userName;
  String date;
  String color;
  final DocumentReference reference;
  List<Dates> dates;

  //this is getting map from database
  Job.fromMap(Map<String, dynamic> map, {this.reference}) {
    name = map['name'];
    date = map['date'];
    userName = map['userName'];
    color = map['color'];
    var lis = map['dates'] as List;
    dates = lis.map((e) => Dates.fromMap(e)).toList();
  }
}
