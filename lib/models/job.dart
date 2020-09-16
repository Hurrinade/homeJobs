import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  String name;
  String userName;
  String date;
  String color;
  final DocumentReference reference;

  //this is getting map from database
  Job.fromMap(Map<String, dynamic> map, {this.reference}) {
    name = map['name'];
    date = map['date'];
    userName = map['userName'];
    color = map['color'];
  }
}
