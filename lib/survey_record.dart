import 'package:cloud_firestore/cloud_firestore.dart';


class SurveyRecord{
  final bool complete;
  final bool question1;
  final int question2;
  final int question3_1;
  final int question3_2;
  final int question3_3;
  final int question4_1;
  final int question4_2;
  final int question4_3;
  final bool question5;
  final int question6;
  final String memo;
  final String id;
  final DocumentReference reference;

  SurveyRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['complete'] != null), //make sure the variable has a non-null value.
        assert(map['question1'] != null), //make sure the variable has a non-null value.
        assert(map['question2']!=null),
        assert(map['question3-1']!=null),
        assert(map['question3-2']!=null),
        assert(map['question3-3']!=null),
        assert(map['question4-1']!=null),
        assert(map['question4-2']!=null),
        assert(map['question4-3']!=null),
        assert(map['question5']!=null),
        assert(map['question6']!=null),
        assert(map['memo']!=null),
        assert(reference.documentID!=null),


        complete = map['complete'],
        question1 = map['question1'],
        question2 = map['question2'],
        question3_1 = map['question3-1'],
        question3_2 = map['question3-2'],
        question3_3 = map['question3-3'],
        question4_1 = map['question4-1'],
        question4_2 = map['question4-2'],
        question4_3 = map['question4-3'],
        question5 = map['question5'],
        question6 = map['question6'],
        memo = map['memo'],
        id = reference.documentID;

  SurveyRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference : snapshot.reference);

}

class SurveyRecordSub{
  final bool complete;
  final bool question1;
  final int question2;
  final int question3_1;
  final int question3_2;
  final int question3_3;
  final int question4_1;
  final int question4_2;
  final int question4_3;
  final bool question5;
  final int question6;
  final String memo;
  final DocumentReference reference;

  SurveyRecordSub.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['complete'] != null), //make sure the variable has a non-null value.
        assert(map['question1'] != null), //make sure the variable has a non-null value.
        assert(map['question2']!=null),
        assert(map['question3-1']!=null),
        assert(map['question3-2']!=null),
        assert(map['question3-3']!=null),
        assert(map['question4-1']!=null),
        assert(map['question4-2']!=null),
        assert(map['question4-3']!=null),
        assert(map['question5']!=null),
        assert(map['question6']!=null),
        assert(map['memo']!=null),

        complete = map['complete'],
        question1 = map['question1'],
        question2 = map['question2'],
        question3_1 = map['question3-1'],
        question3_2 = map['question3-2'],
        question3_3 = map['question3-3'],
        question4_1 = map['question4-1'],
        question4_2 = map['question4-2'],
        question4_3 = map['question4-3'],
        question5 = map['question5'],
        question6 = map['question6'],
        memo = map['memo'];

  SurveyRecordSub.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference : snapshot.reference);
}