import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String? name;
  Timestamp? startTime;
  DateTime? endTime;
  int? workHours;
  List<String>? team;
  bool? status;

  Task(
      {@required this.name,
      this.startTime,
      this.endTime,
      this.workHours,
      this.status,
      this.team
      });
}
