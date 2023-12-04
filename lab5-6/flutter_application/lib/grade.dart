class Grade {
  int? id;
  String? sid;
  String? grade;

  Grade({this.id = null, this.sid, this.grade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sid': sid,
      'grade': grade,
    };
  }

  Grade.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      id = map['id'];
      sid = map['sid'];
      grade = map['grade'];
    }
  }
}
