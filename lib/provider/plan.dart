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

  Future addNewPlan(Plan plan) async {
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('plans');
      // DocumentReference doc =
      await ref.add({
        'name': plan.name,
        'startDate': plan.startDate,
        'endDate': plan.endDate,
        'teamName': plan.teamName,
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

  List<Task> get getTasks => [..._tasks];

  Future<List<Plan>> getPlans() async {
    List<Plan> _plans = [];
    _tasks = [];
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('plans');
      // QuerySnapshot tasksSnapshot;
      QuerySnapshot snapshot = await ref.get(); //get plans collection

      //  ref.get().then((snapshot) {
      //    snapshot.docs.forEach((element) {
      //      ref.doc(element.id).get().then((value) => {

      //      });
      //    });
      //  });

      _plans = snapshot.docs.map((e) {
        String id = e.id;
        // tasksSnapshot = await ref.doc(id).collection('tasks').get();
        ref.doc(id).collection('tasks').get().then((value) {
          _tasks = value.docs.map((e) => Task(name: e['name'])).toList();
        });
        return Plan(
          name: e['name'],
          startDate: e['startDate'],
          endDate: e['endDate'],
          teamName: e['teamName'],
          tasks: _tasks,
        );
      }).toList();

      return _plans;
    } catch (e) {
      print(e);
      print('in error');
      return [];
    }

    // snapshot.docs.forEach(
    //   (element) async {
    //     String id = element.id;
    //     //print(element.get('tasks'));
    //     QuerySnapshot tasksSnapshot =
    //         await ref.doc(id).collection('tasks').get();
    //     //List tasks = sn.docs.map((e) => print(e)).toList();
    //     _tasks = tasksSnapshot.docs.map((e) => Task(name: e['name'])).toList();
    //     // print(sn.docs.map((e) => print(e['startTime'])));
    //     Plan plan = Plan(
    //       name: element['name'],
    //       startDate: element['startDate'],
    //       endDate: element['endDate'],
    //       teamName: element['teamName'],
    //       tasks: _tasks,
    //     );
    //     // _plans.add(plan);
    //     // print(plan.name);
    //     // _plans = snapshot.docs
    //     //     .map((element) => Plan(
    //     //           name: element['name'],
    //     //           startDate: element['startDate'],
    //     //           endDate: element['endDate'],
    //     //           teamName: element['teamName'],
    //     //           tasks: _tasks,
    //     //         ))
    //     //     .toList();
    //   },
    // );
  }
}
