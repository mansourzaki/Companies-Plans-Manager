import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:plansmanager/provider/user.dart' as user;
import 'package:plansmanager/widgets/tasks_calendar.dart';

class Plan with ChangeNotifier {
  String? name;
  Timestamp? startDate;
  Timestamp? endDate;
  String? teamName;
  bool status = false;
  List<Task>? tasks;
  List<Task>? sharedTasks;
  int totalTasks = 0;
  Plan(
      {this.name,
      this.startDate,
      this.endDate,
      this.teamName,
      this.tasks,
      this.sharedTasks});
  // List<Task> _tasks = [];
  String get userId {
    String user = FirebaseAuth.instance.currentUser!.uid;
    return user;
  }

  List<Plan> _plans = [];
  String? current;
  Future<void> getCustomPlan(int month) async {
    try {
      final ref = await FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: month)
          .get();
      if (ref.docs.length == 0) {
        current = null;
        notifyListeners();
      } else {
        current = ref.docs.first.id;
        print('hiiii ${TasksCalendar().month}');
        notifyListeners();
      }

      notifyListeners();
    } catch (err) {}
  }

  Future<void> getCurrentPlan() async {
    try {
      final ref = await FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: TasksCalendar().month.month)
          .get();
      if (ref.docs.length == 0) {
        current = null;
        notifyListeners();
      } else {
        current = ref.docs.first.id;
        print('hiiii ${TasksCalendar().month}');
        notifyListeners();
      }

      notifyListeners();
    } catch (err) {}
  }

  void clearCurrent() {
    current = null;
    notifyListeners();
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
  List<Task> allSharedTasks = [];
  void clearAllTasks() {
    allTasks = [];
    tasks = [];
    notifyListeners();
  }

  Future<void> getAllTasks(int month, {bool? stay}) async {
    print('cleared');
    List<Task> ts = [];
    allTasks = [];
    this.tasks = [];
    sharedTasks = [];
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: month)
          .get()
          .then((value) async {
        if (value.docs.length != 0) {
          await value.docs.first.reference.collection('tasks').get().then(
                (value) => value.docs.forEach(
                  (element) {
                    Timestamp t = element['endTime'];
                    Map<String, dynamic> map = element['users'];

                    ts.add(
                      Task(
                        sharedBy: element['sharedBy'],
                        planId: element.reference.parent.parent!.id,
                        id: element.id,
                        name: element['name'],
                        startTime: element['startTime'],
                        endTime: t.toDate(),
                        status: element['status'],
                        workHours: element['workHours'],
                        teams: element['teams'],
                        type: element['type'],
                        ach: element['ach'],
                        percentage: element['percentage'],
                        notes: element['notes'],
                        shared: element['shared'],
                        users: map.entries
                            .map((e) => user.User(e.key, e.value))
                            .toList(),
                      ),
                    );
                    notifyListeners();
                  },
                ),
              );
        } else {
          return;
        }

        allTasks = ts;
        // allTasks.sort();
        notifyListeners();
        print('leeeength ${allTasks.length}');
        print('leeeength ${ts.length}');
        print('leeeength shared ${sharedTasks!.length}');
      });
//  if (stay == true) {
//           tasks = allTasks;
//           print('in true');
//           notifyListeners();
//         } else {}
      if (allTasks.length != 0) {
        tasks = allTasks
            .where((element) =>
                element.startTime!.toDate().day == DateTime.now().day)
            .toList();
      }
    } catch (error) {
      print('$error in catchh');
    }
  }

  Future<void> setTasksBasedOnSelectedDay(int day) async {
    // await getAllTasks(DateTime.now().month);
    // tasks = allTasks
    //     .where((element) => element.startTime!.toDate().day == day)
    //     .toList();
    // sharedTasks = allSharedTasks
    //     .where((element) => element.startTime!.toDate().day == day)
    //     .toList();
    if (allTasks.length == 0 && allSharedTasks.length == 0) {
      print('equal 0');
      //await getAllTasks(DateTime.now().month);
      notifyListeners();
    } else if (allTasks.length != 0 || allSharedTasks.length != 0) {
      print('have items');
      // List<Task> ts = this.tasks!;
      // tasks = allTasks
      //     .where((element) => element.startTime!.toDate().day == day)
      //     .toList();
      tasks = allTasks
          .where((element) => element.startTime!.toDate().day == day)
          .toList();
      sharedTasks = allSharedTasks
          .where((element) => element.startTime!.toDate().day == day)
          .toList();
      print(tasks!.length);
      // this.tasks = ts;
      print('in today');
      notifyListeners();
    } else if (allTasks.length == 0) {
      print('equal 0');
      await getAllTasks(DateTime.now().month);
      notifyListeners();
    }
  }

  Future<void> setTasksBasedOnSelectedMonth(int month) async {
    getCurrentPlan();
    if (allTasks.length == 0 || allSharedTasks.length == 0) {
      print('no tasks');
    } else if (this.tasks!.length == 0) {
      await getAllTasks(DateTime.now().month);
      notifyListeners();
    } else if (this.sharedTasks!.length == 0) {
      await getSharedTasks(DateTime.now().month);
      notifyListeners();
    }
    // if (this.tasks!.length != 0) {
    tasks = allTasks
        .where((element) => element.startTime!.toDate().month == month)
        .toList();
    sharedTasks = allSharedTasks
        .where((element) => element.startTime!.toDate().month == month)
        .toList();
    print(tasks!.length);
    // this.tasks = ts;
    print('in monthhhh ${tasks!.length}');
    notifyListeners();
    // }
  }

  // List<Task> getTasks() {
  //   notifyListeners();
  //   return tasks!;
  // }

  Future<void> getSharedTasks(int month) async {
    try {
      List<Task> mySharedTask = [];
      allSharedTasks = [];
      int count = 0;
      var snapshot = await FirebaseFirestore.instance
          .collection('sharedTasks')
          .where('recieversId', arrayContains: userId)
          .get();
      for (QueryDocumentSnapshot docs in snapshot.docs) {
        var t = await FirebaseFirestore.instance
            .collection('plans')
            .where('month', isEqualTo: month)
            .where('userId', isEqualTo: docs['ownerId'])
            .get();
        print('count ${count++}');

        t.docs.forEach((element) async {
          var d = await element.reference
              .collection('tasks')
              .doc(docs['taskId'])
              .get();

          var x = d.data();

          if (x != null) {
            Timestamp t = x['endTime'];
            Map<String, dynamic> map = x['users'];

            Task ts = Task(
              sharedBy: x['sharedBy'],
              planId: docs['planId'],
              id: docs['taskId'],
              name: x['name'],
              startTime: x['startTime'],
              endTime: t.toDate(),
              status: x['status'],
              workHours: x['workHours'],
              teams: x['teams'],
              type: x['type'],
              ach: x['ach'],
              shared: x['shared'],
              percentage: x['percentage'],
              notes: x['notes'],
              users: map.entries.map((e) => user.User(e.key, e.value)).toList(),
            );

            mySharedTask.add(ts);
            allSharedTasks = mySharedTask;
            sharedTasks = allSharedTasks
                .where((element) =>
                    element.startTime!.toDate().day == DateTime.now().day)
                .toList();
            print('leen ${allSharedTasks.length}');
            notifyListeners();
          }
        });

        //   var d = await t.docs.first.reference
        // .collection('tasks')
        // .doc(docs['taskId'])
        // .get();

      }
      notifyListeners();
    } catch (error) {
      print('in getSharedTasks $error');
      notifyListeners();
    }
  }

  Stream sharedTasksSnapshot() {
    Stream d = FirebaseFirestore.instance
        .collection('sharedTasks')
        .where('recieversId', arrayContains: userId)
        .snapshots();
    print('dffff');

    d.forEach((element) {
      return element.docs.forEach((e) {
        return FirebaseFirestore.instance
            .collection('plans')
            .doc(e.data()['planId'])
            .collection('tasks')
            .doc(e.data()['taskId'])
            .snapshots();
      });
    });

    return d;
  }

//new add task
  Future<void> addTask(Task task, int month) async {
    try {
      FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: month)
          .get()
          .then((value) async {
        print(value.docs.length);

        Map f = Map<String, String>.fromIterable(task.users!,
            key: (item) => item.id, value: (item) => item.name);

        if (value.docs.length != 0) {
          print('${task.shared} + ${task.users!.length} hjj');
          final ref = await value.docs.first.reference.collection('tasks').add({
            'name': task.name,
            'sharedBy': userId,
            'startTime': task.startTime,
            'endTime': task.endTime,
            'status': task.status,
            'workHours': task.workHours,
            'teams': task.teams,
            'type': task.type,
            'ach': task.ach,
            'percentage': task.percentage,
            'notes': task.notes,
            'shared': task.shared,
            'users': f,
          });
          print(ref.id);
          allTasks.add(Task(
              planId: ref.parent.parent!.id,
              id: ref.id,
              name: task.name,
              startTime: task.startTime,
              endTime: task.endTime,
              status: task.status,
              workHours: task.workHours,
              teams: task.teams,
              type: task.type,
              ach: task.ach,
              percentage: task.percentage,
              notes: task.notes,
              sharedBy: userId,
              shared: task.shared,
              users: task.users));
          if (task.shared == true) {
            print('foooo');
            FirebaseFirestore.instance.collection('sharedTasks').add({
              'planId': ref.parent.parent!.id,
              'taskId': ref.id,
              'ownerId': userId,
              'recieversId': f.keys.toList()
            });
          }
          print('added ${allTasks[allTasks.length - 1].id}');
          setTasksBasedOnSelectedDay(DateTime.now().day);
          //  await getAllTasks(month);
          notifyListeners();
          print('notified lintners');
        } else {
          notifyListeners();
          print('in else');
        }
      });
    } catch (error) {
      print('error catch ${error.toString()}');
      notifyListeners();
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

  // Future<void> addTaskSingleCollection(
  //     Task task, int month, String userId) async {
  //   try {
  //     Map f = Map<String, String>.fromIterable(task.users!,
  //         key: (item) => item.id, value: (item) => item.name);
  //     FirebaseFirestore.instance.collection('tasks').add({
  //       'planId':getCurrentPlan(),
  //       'name': task.name,
  //       'startTime': task.startTime,
  //       'endTime': task.endTime,
  //       'status': task.status,
  //       'workHours': task.workHours,
  //       'teams': task.teams,
  //       'type': task.type,
  //       'ach': task.ach,
  //       'percentage': task.percentage,
  //       'notes': task.notes,
  //       'shared': task.shared,
  //       'users': f,
  //     });
  //   } catch (error) {}
  // }

  Future<void> addTaskWithCustomId(Task task, int month, String userId) async {
    try {
      FirebaseFirestore.instance
          .collection('plans')
          .where('userId', isEqualTo: userId)
          .where('month', isEqualTo: month)
          .get()
          .then((value) async {
        print(value.docs.length);
        if (value.docs.length != 0) {
          final ref = await value.docs.first.reference.collection('tasks').add({
            'name': task.name,
            'startTime': task.startTime,
            'endTime': task.endTime,
            'status': task.status,
            'workHours': task.workHours,
            'teams': task.teams,
            'type': task.type,
            'ach': task.ach,
            'percentage': task.percentage,
            'notes': task.notes,
            'shared': task.users!.isEmpty ? false : true
          });
          print(ref.id);
          allTasks.add(Task(
              id: ref.id,
              name: task.name,
              startTime: task.startTime,
              endTime: task.endTime,
              status: task.status,
              workHours: task.workHours,
              teams: task.teams,
              type: task.type,
              ach: task.ach,
              percentage: task.percentage,
              notes: task.notes));
          print('added ${allTasks[allTasks.length - 1].id}');
          setTasksBasedOnSelectedDay(DateTime.now().day);
          //  await getAllTasks(month);
          notifyListeners();
          print('notified lintners');
        } else {
          notifyListeners();
          print('in else');
        }
      });
    } catch (error) {
      print('error catch ${error.toString()}');
      notifyListeners();
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

  Future<void> updateTask(Task task, String planId) async {
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .doc(task.planId)
          .collection('tasks')
          .doc(task.id)
          .update({
        'name': task.name,
        'startTime': task.startTime,
        'sharedBy': task.sharedBy,
        'endTime': task.endTime,
        'status': task.status,
        'workHours': task.workHours,
        'teams': task.teams,
        'type': task.type,
        'ach': task.ach,
        'percentage': task.percentage,
        'notes': task.notes,
        'shared': task.shared,
        'users': Map<String, String>.fromIterable(task.users!,
            key: (item) => item.id, value: (item) => item.name)
      });
      print('done plan $planId}');
      print('done ${task.id}');
      if (task.users!.isNotEmpty) {
        var docRef =
            FirebaseFirestore.instance.collection('sharedTasks').doc(task.id);
        docRef.get().then((value) {
          if (value.exists) {
            value.reference.update({'users': task.users});
          } else {
            Map f = Map<String, String>.fromIterable(task.users!,
                key: (item) => item.id, value: (item) => item.name);
            FirebaseFirestore.instance.collection('sharedTasks').add({
              'planId': task.planId,
              'taskId': task.id,
              'ownerId': userId,
              'recieversId': f.keys.toList()
            });
          }
        });
      }
      if (task.shared == true && sharedTasks != null) {
        sharedTasks!.removeWhere((element) => element.id == task.id);
        sharedTasks!.add(task);
      } else {
        allTasks.removeWhere((element) => element.id == task.id);
        allTasks.add(task);
      }
      setTasksBasedOnSelectedDay(DateTime.now().day);
      notifyListeners();
    } catch (error) {
      print(error);
      notifyListeners();
    }
  }

  Future<int> getTasksLength(String planId) async {
    var ref = await FirebaseFirestore.instance
        .collection('plans')
        .doc(planId)
        .collection('tasks')
        .get();
    this.totalTasks = ref.docs.length;
    notifyListeners();
    return this.totalTasks;
  }

  Future<void> updateTaskSatus(Task task, bool status) async {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('plans')
        .doc(task.planId)
        .collection('tasks');
    await ref.doc(task.id).update({
      'status': status,
    });
    var trueDocs = await ref.where('status', isEqualTo: true).get();
    var allDocs = await ref.get();
    int trueLength = trueDocs.docs.length;
    int allLength = allDocs.docs.length;
    double perc = double.parse((trueLength / allLength).toStringAsFixed(2));
    await FirebaseFirestore.instance
        .collection('plans')
        .doc(task.planId)
        .update({
      'percentage': perc,
    });

    allTasks.firstWhere((element) => element.id == task.id).status = status;

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection('plans')
          .doc(current)
          .collection('tasks')
          .doc(task.id)
          .delete();
      allTasks.removeWhere((element) => element.id == task.id);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      notifyListeners();
    }
    notifyListeners();
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

  // void getTodayTasks() {
  //   if (this.tasks!.length != 0) {
  //     List<Task> ts = this.tasks!;
  //     ts.where(
  //         (element) => element.startTime!.toDate().day == DateTime.now().day);
  //     print(ts.length);
  //     this.tasks = ts;
  //     print('in today');
  //   }
  //   notifyListeners();
  // }

  //List<Task> get getTasks => [..._tasks];

  List<Plan> get plans {
    return [..._plans];
  }

//new add
  Future<void> addPlanNewVersion(String name, int month) async {
    CollectionReference ref = FirebaseFirestore.instance.collection('plans');
    final docs = await ref
        .where('userId', isEqualTo: userId)
        .where('month', isEqualTo: month)
        .get();

    if (docs.docs.length == 0) {
      print('${docs.docs.length} doocs');
      print('adding');
      ref.add({'name': name, 'month': month, 'userId': userId});
    } else {
      throw Exception('Already Exists Exception');
    }
  }

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

  Plan get currentMonthPlan {
    Plan plan = _plans.firstWhere((element) {
      return element.startDate!.toDate().month == DateTime.now().month;
    });
    return plan;
  }

  List<Task> todaysTasks = [];
  List<Task> monthTasks = [];
  // Future<List<Task>> getCurrentDayTasks() async {
  //   try {
  //     if (_plans.length == 0) {
  //       List<Plan> plans = await getPlans(month: DateTime.now().month);
  //       plans.forEach((element) {
  //         print(
  //             '${element.tasks} + this is task for plan ${element.name} from first if');
  //         todaysTasks = element.tasks!.where((element) {
  //           return element.startTime!.toDate().day == DateTime.now().day;
  //         }).toList();
  //       });
  //       // print('$todaysTasks + this is today tasks from first if');
  //       return todaysTasks;
  //     } else {
  //       print('in method');
  //       // todaysTasks = tasks!.where((element) {
  //       //   return element.startTime!.day == DateTime.now().day;
  //       // }).toList();
  //       _plans.forEach((element) {
  //         todaysTasks = element.tasks!
  //             .where((element) =>
  //                 element.startTime!.toDate().day == DateTime.now().day)
  //             .toList();
  //       });
  //       print('$todaysTasks + this is today tasks from second if');
  //       //notifyListeners();
  //       return todaysTasks;
  //     }
  //   } catch (error) {
  //     print('$error + in catch');
  //     return [];
  //   }
  // }

  // List<Task> getCurrentMonthTasks() {
  //   monthTasks = [];
  //   monthTasks = tasks!.where((element) {
  //     return element.startTime!.toDate().month == DateTime.now().month;
  //   }).toList();
  //   return monthTasks;
  // }

  // Future<List<Plan>> getPlans({int? month}) async {
  //   // List<Plan> _plans = [];
  //   //_tasks = [];
  //   List<Task> _tasks = [];
  //   try {
  //     CollectionReference ref = FirebaseFirestore.instance.collection('plans');
  //     // QuerySnapshot tasksSnapshot;
  //     QuerySnapshot snapshot = await ref.get(); //get plans collection
  //     snapshot.docs.toList();

  //     if (month == null || month == 0) {
  //       _plans = snapshot.docs.map((e) {
  //         String id = e.id;
  //         // tasksSnapshot = await ref.doc(id).collection('tasks').get();
  //         ref.doc(id).collection('tasks').get().then((value) {
  //           _tasks = value.docs
  //               .map((e) => Task(name: e['name'], startTime: Timestamp.now()))
  //               .toList();
  //         });
  //         return Plan(
  //           name: e['name'],
  //           startDate: e['startDate'],
  //           endDate: e['endDate'],
  //           teamName: e['teamName'],
  //           tasks: _tasks,
  //         );
  //       }).toList();
  //     } else if (month > 0 && month <= 12) {
  //       _plans = snapshot.docs.where((e) {
  //         Timestamp stDate = e['startDate'];
  //         // Timestamp edDate = e['endDate'];
  //         return month == stDate.toDate().month;
  //         // return (start.isAfter(stDate.toDate()) &&
  //         //     end.isBefore(edDate.toDate()));
  //       }).map((e) {
  //         String id = e.id;
  //         // tasksSnapshot = await ref.doc(id).collection('tasks').get();
  //         ref.doc(id).collection('tasks').get().then((value) {
  //           print('inside get plans with month');
  //           _tasks = value.docs
  //               .map((e) => Task(name: e['name'], startTime: Timestamp.now()))
  //               .toList();
  //           print('${_tasks.first.name} Fiiiiirst of list');
  //         });
  //         return Plan(
  //           name: e['name'],
  //           startDate: e['startDate'],
  //           endDate: e['endDate'],
  //           teamName: e['teamName'],
  //           tasks: _tasks,
  //         );
  //       }).toList();
  //     }
  //     notifyListeners();
  //     return _plans;
  //   } catch (e) {
  //     print(e);
  //     print('in error');
  //     return [];
  //   }
  // }

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