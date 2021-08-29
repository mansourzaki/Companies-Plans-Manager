import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/user.dart';

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
  String? ownerName;
  List<User>? users;
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
      this.sharedBy,
      this.users = const []});

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

  Future<String> getTaskOwner(String id) async {
    try {
      // this.ownerName = '';
      DocumentSnapshot ref =
          await FirebaseFirestore.instance.collection('users').doc(id).get();
      // User user = User(id, ref['name'],
      //     email: ref['email'], isLeader: ref['isLeader'], team: ref['teamName']);
      this.ownerName = '...';
      this.ownerName = ref['name'];
      notifyListeners();
      return this.ownerName!;
    } catch (error) {
      print('catcho $error');
      return 'dd';
    }
  }
}
