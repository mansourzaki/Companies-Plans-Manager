import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';

class Plan with ChangeNotifier {
  String? name;
  Timestamp? startDate;
  Timestamp? endDate;
  String? teamName;
  bool status = false;
  List<Task>? tasks = [];

  Plan({
    this.name,
    this.startDate,
    this.endDate,
    this.teamName,
    this.tasks,
  });
  List<Task> _tasks = [];
  Future addNewPlan(String x) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('plans');
      DocumentReference doc = await ref.add({
        'name': x,
        'startDate': Timestamp.now(),
        'endDate': Timestamp.fromDate(DateTime.utc(2021, 8)),
        'teamName': 't2',
      }).then((value) {
        value.collection('tasks').add({
          'name': 'تاسك 2',
          'startTime': Timestamp.now(),
          'endTime': Timestamp.now()
        });
        notifyListeners();
        return value;
      });
    } catch (e) {
      print(e);
    }
  }

  Future getPlans() async {
    CollectionReference ref = FirebaseFirestore.instance.collection('plans');

    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('plans').get();

    snapshot.docs.forEach((element) async {
      String id = element.id;
      //print(element.get('tasks'));
      QuerySnapshot sn = await ref.doc(id).collection('tasks').get();
      //List tasks = sn.docs.map((e) => print(e)).toList();
      _tasks = sn.docs.map((e) => Task(name: e['name'])).toList();
      // print(sn.docs.map((e) => print(e['startTime'])));
      Plan(
        name: element['name'],
        startDate: element['startDate'],
        endDate: element['endDate'],
        teamName: element['teamName'],
        tasks: _tasks,
      );
      _tasks.forEach((element) {
        print(element.name);
      });
    });
  }
}
