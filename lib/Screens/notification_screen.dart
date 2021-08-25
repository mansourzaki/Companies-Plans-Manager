import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:plansmanager/provider/user.dart';
import 'package:plansmanager/widgets/task_card.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key, this.snapshot1}) : super(key: key);
  final AsyncSnapshot<QuerySnapshot>? snapshot1;

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Task> tasks = [];
  List<String> plansId = [];
  List<String> tasksId = [];
  Stream<QuerySnapshot>? stream;
  Set ids = {};
  @override
  void initState() {
    if (widget.snapshot1 != null) {
      List<Stream<QuerySnapshot>> s = widget.snapshot1!.data!.docs.map((e) {
        print('looop ${e['planId']}');
        ids.add(e['taskId']);
        // planIds.add(e['planId']);
        return FirebaseFirestore.instance
            .collection('plans')
            .doc(e['planId'])
            .collection('tasks')
            .snapshots();
      }).toList();
      stream = StreamGroup.merge(s);
      // widget.docs!.map((e) {
      //   Timestamp t = e['endTime'];
      //   Map<String, dynamic> map = e['users'];
      //   //  print('lala ${e.reference.parent.parent!.id}');
      //   return Task(
      //     sharedBy: e['sharedBy'],
      //     planId: e.reference.parent.parent!.id,
      //     id: e.id,
      //     name: e['name'],
      //     startTime: e['startTime'],
      //     endTime: t.toDate(),
      //     status: e['status'],
      //     workHours: e['workHours'],
      //     teams: e['teams'],
      //     type: e['type'],
      //     ach: e['ach'],
      //     shared: e['shared'],
      //     percentage: e['percentage'],
      //     notes: e['notes'],
      //     users: map.entries.map((e) => User(e.key, e.value)).toList(),
      //   );
      // }).toList();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text('الإشعارات'),
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: stream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('an error has occured');
            }
            tasks = snapshot.data!.docs
                .where((element) => ids.contains(element.id))
                .map((e) {
              Timestamp t = e['endTime'];
              Map<String, dynamic> map = e['users'];
              //  print('lala ${e.reference.parent.parent!.id}');
              return Task(
                sharedBy: e['sharedBy'],
                planId: e.reference.parent.parent!.id,
                id: e.id,
                name: e['name'],
                startTime: e['startTime'],
                endTime: t.toDate(),
                status: e['status'],
                workHours: e['workHours'],
                teams: e['teams'],
                type: e['type'],
                ach: e['ach'],
                shared: e['shared'],
                percentage: e['percentage'],
                notes: e['notes'],
                users: map.entries.map((e) => User(e.key, e.value)).toList(),
              );
            }).toList();
            return ListView.separated(
                itemBuilder: (context, i) {
                  return TaskCard(task: tasks[i], id: tasks[i].id);
                },
                separatorBuilder: (context, i) => Divider(),
                itemCount: tasks.length);
          },
        ));
  }
}
