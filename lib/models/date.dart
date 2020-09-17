class Dates {
  String date;
  String user;

  Dates({this.date, this.user});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'user': user,
    };
  }

  Dates.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    user = map['user'];
  }
}
