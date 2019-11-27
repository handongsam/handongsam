import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class UserRecord{
  final int alarmBefore;
  final bool alarmReplay;
  final bool alarmSet;
  final Timestamp alarmStamp;
  final Timestamp startTime;
  final Timestamp endTime;
  final DocumentReference reference;

  UserRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['alarmBefore'] != null), //make sure the variable has a non-null value.
        assert(map['alarmReplay'] != null), //make sure the variable has a non-null value.
        assert(map['alarmSet']!=null),
        assert(map['alarmStamp']!=null),
        assert(map['startTime']!=null),
        assert(map['endTime']!=null),

        alarmBefore = map['alarmBefore'],
        alarmReplay = map['alarmReplay'],
        alarmSet = map['alarmSet'],
        alarmStamp = map['alarmStamp'],
        startTime = map['startTime'],
        endTime = map['endTime'];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference : snapshot.reference);
}

