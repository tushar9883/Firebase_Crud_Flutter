import 'package:firebase_helpers/firebase_helpers.dart';

import '../Model/StudentDetails.dart';

class DbHelp {
  static const String STUDENT_DB = "STUDENT";

  DatabaseService<StudDetails> userdb = DatabaseService('Student',
      fromDS: (id, data) => StudDetails.fromJson(id, data),
      toMap: (data) => data.toJson());

  ///Todo Create Table
  Future addStudent(StudDetails studDetails) async {
    await userdb.create(studDetails.toJson());
  }

  ///Todo All Details Get In Table
  Future<List<StudDetails>> getDetailss() async {
    List<StudDetails> res = await userdb.getQueryList(
      orderBy: [OrderBy("date", descending: true)],
    );
    return res;
  }

  ///Todo Update Details
  Future updateDetails(StudDetails studDetails) async {
    await userdb.updateData(studDetails.uid ?? '', studDetails.toJson());
  }

  ///Todo Remove Data
  Future removeDetails(StudDetails studDetails) async {
    await userdb.removeItem(studDetails.uid ?? '');
  }
}
