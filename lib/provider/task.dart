import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task with ChangeNotifier {
  String? planId;
  String? id;
  String? name;
  Timestamp? startTime;
  DateTime? endTime;
  int? workHours;
  List? teams;
  bool? status;
  String? type;
  String? ach;
  int? percentage;
  String? notes;
  bool shared;
  String? sharedBy;
  Task(
      {this.planId,
      this.id,
      this.name,
      this.startTime,
      this.endTime,
      this.workHours,
      this.status,
      this.teams,
      this.percentage,
      this.notes,
      this.ach,
      this.type,
      this.shared = false,
      this.sharedBy});

  // Future updateTaskSatus(Task task,String current, bool status) async {
  //   await FirebaseFirestore.instance
  //       .collection('plans')
  //       .doc(current)
  //       .collection('tasks')
  //       .doc(this.id)
  //       .update({
  //     'status': status,
  //   });

  //   notifyListeners();
  // }
}
