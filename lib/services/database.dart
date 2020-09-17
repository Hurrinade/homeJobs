import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //collection reference
  final CollectionReference jobCollection =
      FirebaseFirestore.instance.collection('Jobs');

  //stream that updates data on home page
  Stream<QuerySnapshot> get jobData {
    return jobCollection.snapshots();
  }

//updating job with it's name and date which are collection map
//name is also id for jobs
  Future updateJob(
    String name,
    String date,
    String userName,
    String color,
    List<Map> dates,
  ) async {
    return await jobCollection.doc(name).set({
      'name': name,
      'date': date,
      'userName': userName,
      'color': color,
      'dates': dates,
    });
  }
}
