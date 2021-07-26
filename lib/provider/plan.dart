import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';

class Plan with ChangeNotifier {
  String? name;
  Timestamp? startDate;
  Timestamp? endDate;
  String? teamName;
  bool status = false;
  List<Task>? tasks;

  Plan({
    this.name,
    this.startDate,
    this.endDate,
    this.teamName,
    this.tasks,
  });
  // List<Task> _tasks = [];
  String userId = FirebaseAuth.instance.currentUser!.uid;
  List<Plan> _plans = [];

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

//new add
  void addPlan(Plan plan, int month, BuildContext context) {
    try {
      print('in method');
      final ref = FirebaseFirestore.instance.collection('plans');

      ref
          .where('month', isEqualTo: month)
          .where('userId', isEqualTo: userId)
          .get()
          .then((value) {
        print('${value.docs.length} + teeest');
        if (value.docs.length == 0) {
          ref.add({
            'name': plan.name,
            'userId': userId,
            'month': month,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('You already have a plan on this month'),
            backgroundColor: Theme.of(context).errorColor,
          ));
        }
      });
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection('Plans')
      //     .add({
      //   'name': plan.name,
      //   'startDate': plan.startDate,
      //   'month': DateTime.now().month,
      //   'endDate': plan.endDate,
      // });
    } catch (error) {
      print(error);
    }
  }
  List<Task> allTasks = [];

  Future<void> getAllTasks(int month) async {
    print('cleared');
    List<Task> ts = [];
    await FirebaseFirestore.instance
        .collection('plans')
        .where('userId', isEqualTo: userId)
        .where('month', isEqualTo: month)
        .get()
        .then((value) async {
      value.docs.first.reference
          .collection('tasks')
          .get()
          .then((value) => value.docs.forEach((element) {
                Timestamp t = element['endTime'];
                ts.add(Task(
                    name: element['name'],
                    startTime: element['startTime'],
                    endTime: t.toDate(),
                    status: element['status']));
              }));
    });
    this.tasks = ts;
  }

  Future<void> setTasksBasedOnSelectedDay(int day) async {
    if (this.tasks == null) {
      print('equal null');
      await getAllTasks(DateTime.now().month);
      notifyListeners();
    } else if (this.tasks!.length == 0) {
      print('equal 0');
      await getAllTasks(DateTime.now().month);
      notifyListeners();
    } else if (this.tasks!.length != 0) {
      print('have items');
      // List<Task> ts = this.tasks!;
      tasks = tasks!
          .where((element) => element.startTime!.toDate().day == day)
          .toList();
      print(tasks!.length);
      // this.tasks = ts;
      print('in today');
      notifyListeners();
    }
  }

  void setTasksBasedOnSelectedMonth(int month) {
    if (this.tasks!.length == 0) {
      getAllTasks(DateTime.now().month);
    }
    if (this.tasks!.length != 0) {
      List<Task> ts = this.tasks!;
      tasks = ts
          .where((element) => element.startTime!.toDate().month == month)
          .toList();
      print(ts.length);
      // this.tasks = ts;
      print('in monthhhh ${tasks!.length}');
    }
    notifyListeners();
  }

  List<Task> getTasks() {
    notifyListeners();
    return tasks!;
  }

//new add task
  void addTask(Task task, int month) async {
    try {
      FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: month)
          .get()
          .then((value) {
        print(value.docs.length);
        if (value.docs.length != 0) {
          value.docs.first.reference.collection('tasks').add({
            'name': task.name,
            'startTime': task.startTime,
            'endTime': task.endTime,
            'status': task.status,
            'workHours': task.workHours,
            'teams': task.teams,
            'type': task.type,
            'ach': task.ach,
            'percentage': task.percentage,
            'notes': task.notes
          });
          notifyListeners();
        } else {
          print('else teeeeest');
        }
      });
    } catch (error) {
      print('error ${error.toString()}');
    }
    //CollectionReference ref = FirebaseFirestore.instance.collection('Plans');
    // ref.doc(id).collection('tasks').add({
    //   'name': task.name,
    //   'startTime': task.startTime,
    //   'workHours': task.workHours,
    //   'team': ['sdf', 'dfdf', 'dfdf'],
    // });
    // List<Plan> plansList = await getPlans(month: DateTime.now().month);
  }

  void getPlansNewVerison(int month) {
    try {
      if (month > 0 && month <= 12) {
        List<Future<Plan>> ls = [];
        FirebaseFirestore.instance
            .collection('plans')
            .where('userId', isEqualTo: userId)
            .where('month', isEqualTo: month)
            .get()
            .then((value) {
          print(value.docs.length);
          List<Task> ts = [];

          value.docs.forEach((e) {
            Plan(
              name: e['name'],
              startDate: e['startDate'],
              endDate: e['endDate'],
              tasks: ts,
            );
          });
          // value.docs.map((e) async {
          //   return Plan(
          //       name: e['name'],
          //       startDate: e['startDate'],
          //       endDate: e['endDate'],
          //       tasks: await e.reference.collection('tasks').get().then(
          //           (value) => value.docs
          //               .map((e) => Task(name: e['name'], status: e['status']))
          //               .toList()));
          // }).toList();
        });
        print('length ${ls.length}');
      } else {
        print('else');
      }
    } catch (error) {
      print('catch');
    }
  }

  void getTodayTasks() {
    if (this.tasks!.length != 0) {
      List<Task> ts = this.tasks!;
      ts.where(
          (element) => element.startTime!.toDate().day == DateTime.now().day);
      print(ts.length);
      this.tasks = ts;
      print('in today');
    }
    notifyListeners();
  }

  //List<Task> get getTasks => [..._tasks];

  List<Plan> get plans {
    return [..._plans];
  }

  Plan get currentMonthPlan {
    Plan plan = _plans.firstWhere((element) {
      return element.startDate!.toDate().month == DateTime.now().month;
    });
    return plan;
  }

  List<Task> todaysTasks = [];
  List<Task> monthTasks = [];
  Future<List<Task>> getCurrentDayTasks() async {
    try {
      if (_plans.length == 0) {
        List<Plan> plans = await getPlans(month: DateTime.now().month);
        plans.forEach((element) {
          print(
              '${element.tasks} + this is task for plan ${element.name} from first if');
          todaysTasks = element.tasks!.where((element) {
            return element.startTime!.toDate().day == DateTime.now().day;
          }).toList();
        });
        // print('$todaysTasks + this is today tasks from first if');
        return todaysTasks;
      } else {
        print('in method');
        // todaysTasks = tasks!.where((element) {
        //   return element.startTime!.day == DateTime.now().day;
        // }).toList();
        _plans.forEach((element) {
          todaysTasks = element.tasks!
              .where((element) =>
                  element.startTime!.toDate().day == DateTime.now().day)
              .toList();
        });
        print('$todaysTasks + this is today tasks from second if');
        //notifyListeners();
        return todaysTasks;
      }
    } catch (error) {
      print('$error + in catch');
      return [];
    }
  }

  List<Task> getCurrentMonthTasks() {
    monthTasks = [];
    monthTasks = tasks!.where((element) {
      return element.startTime!.toDate().month == DateTime.now().month;
    }).toList();
    return monthTasks;
  }

  Future<List<Plan>> getPlans({int? month}) async {
    // List<Plan> _plans = [];
    //_tasks = [];
    List<Task> _tasks = [];
    try {
      CollectionReference ref = FirebaseFirestore.instance.collection('plans');
      // QuerySnapshot tasksSnapshot;
      QuerySnapshot snapshot = await ref.get(); //get plans collection
      snapshot.docs.toList();

      if (month == null || month == 0) {
        _plans = snapshot.docs.map((e) {
          String id = e.id;
          // tasksSnapshot = await ref.doc(id).collection('tasks').get();
          ref.doc(id).collection('tasks').get().then((value) {
            _tasks = value.docs
                .map((e) => Task(name: e['name'], startTime: Timestamp.now()))
                .toList();
          });
          return Plan(
            name: e['name'],
            startDate: e['startDate'],
            endDate: e['endDate'],
            teamName: e['teamName'],
            tasks: _tasks,
          );
        }).toList();
      } else if (month > 0 && month <= 12) {
        _plans = snapshot.docs.where((e) {
          Timestamp stDate = e['startDate'];
          // Timestamp edDate = e['endDate'];
          return month == stDate.toDate().month;
          // return (start.isAfter(stDate.toDate()) &&
          //     end.isBefore(edDate.toDate()));
        }).map((e) {
          String id = e.id;
          // tasksSnapshot = await ref.doc(id).collection('tasks').get();
          ref.doc(id).collection('tasks').get().then((value) {
            print('inside get plans with month');
            _tasks = value.docs
                .map((e) => Task(name: e['name'], startTime: Timestamp.now()))
                .toList();
            print('${_tasks.first.name} Fiiiiirst of list');
          });
          return Plan(
            name: e['name'],
            startDate: e['startDate'],
            endDate: e['endDate'],
            teamName: e['teamName'],
            tasks: _tasks,
          );
        }).toList();
      }
      notifyListeners();
      return _plans;
    } catch (e) {
      print(e);
      print('in error');
      return [];
    }
  }

  // Future<List<Plan>> plansBasedOnMonth(int month) async {
  //   // List<Plan> _plans = [];
  //   _tasks = [];
  //   try {
  //     CollectionReference ref = FirebaseFirestore.instance.collection('plans');
  //     // QuerySnapshot tasksSnapshot;
  //     QuerySnapshot snapshot = await ref.get(); //get plans collection
  //     _plans = snapshot.docs.where((e) {
  //       Timestamp stDate = e['startDate'];
  //       // Timestamp edDate = e['endDate'];
  //       return month == stDate.toDate().month;
  //       // return (start.isAfter(stDate.toDate()) &&
  //       //     end.isBefore(edDate.toDate()));
  //     }).map((e) {
  //       String id = e.id;
  //       // tasksSnapshot = await ref.doc(id).collection('tasks').get();
  //       ref.doc(id).collection('tasks').get().then((value) {
  //         _tasks = value.docs.map((e) => Task(name: e['name'])).toList();
  //       });
  //       return Plan(
  //         name: e['name'],
  //         startDate: e['startDate'],
  //         endDate: e['endDate'],
  //         teamName: e['teamName'],
  //         tasks: _tasks,
  //       );
  //     }).toList();
  //     print('from map');
  //     print(_plans);
  //     return _plans;
  //   } catch (e) {
  //     print(e);
  //     print('in error');
  //     return [];
  //   }
  // }
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