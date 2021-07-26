import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task {
  String? name;
  Timestamp? startTime;
  DateTime? endTime;
  int? workHours;
  List<String>? teams;
  bool? status;
  String? type;
  String? ach;
  int? percentage;
  String? notes;

  Task(
      {this.name,
      this.startTime,
      this.endTime,
      this.workHours,
      this.status,
      this.teams,
      this.percentage,
      this.notes,
      this.ach,
      this.type});
}
