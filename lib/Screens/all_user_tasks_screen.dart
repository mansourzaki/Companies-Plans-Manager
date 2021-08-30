import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:plansmanager/Screens/Test_add_edit_task.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:plansmanager/provider/user.dart';

class AllUsersTasks extends StatefulWidget {
  const AllUsersTasks({Key? key, this.doc}) : super(key: key);
  final QueryDocumentSnapshot? doc;

  @override
  _AllUsersTasksState createState() => _AllUsersTasksState();
}

class _AllUsersTasksState extends State<AllUsersTasks> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Color(0xffF0F4FD),
          title: Text(' مهام شهر ${widget.doc!['month']}',
              textDirection: TextDirection.rtl),
          centerTitle: true,
          bottom: TabBar(tabs: [
            Tab(
              child: Text(
                'المهام الغير منجزة',
                style: TextStyle(
                    color: Colors.red[600], fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'المهام المنجزة',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            )
          ]),
        ),
        body: StreamBuilder(
          stream: widget.doc!.reference.collection('tasks').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Task> tasks = [];
            List<Task> finishedTasks = [];
            List<Task> unFinishedTasks = [];
            snapshot.data!.docs.isEmpty
                ? Center(child: Text('No Plans For This User!'))
                : Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView.separated(
                        itemBuilder: (context, i) {
                          Timestamp t = snapshot.data!.docs[i]['endTime'];
                          DateTime d = t.toDate();
                          String date = intl.DateFormat('y/M/dd').format(d);
                          Map<String, dynamic> map =
                              snapshot.data!.docs[i]['users'];
                          Task task = Task(
                            // sharedBy: snapshot.data!.docs[i]['sharedBy'],
                            id: snapshot.data!.docs[i].id,
                            name: snapshot.data!.docs[i]['name'],
                            startTime: snapshot.data!.docs[i]['startTime'],
                            endTime: d,
                            status: snapshot.data!.docs[i]['status'],
                            workHours: snapshot.data!.docs[i]['workHours'],
                            teams: snapshot.data!.docs[i]['teams'],
                            type: snapshot.data!.docs[i]['type'],
                            ach: snapshot.data!.docs[i]['ach'],
                            shared: snapshot.data!.docs[i]['shared'],
                            percentage: snapshot.data!.docs[i]['percentage'],
                            notes: snapshot.data!.docs[i]['notes'],
                            users: map.entries
                                .map((e) => User(e.key, e.value))
                                .toList(),
                          );
                          return ListTile(
                            trailing: Icon(Icons.task),
                            title: Text(
                              snapshot.data!.docs[i]['name'],
                              textAlign: TextAlign.right,
                            ),
                            subtitle: Text(
                              date,
                              textAlign: TextAlign.right,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TestAddEditScreen(
                                            task: task,
                                            isAdmin: true,
                                          )));
                            },
                          );
                        },
                        separatorBuilder: (context, i) {
                          return Divider();
                        },
                        itemCount: snapshot.data!.docs.length),
                  );
            if (snapshot.data != null) {
              tasks = snapshot.data!.docs.map((e) {
                Timestamp t = e['endTime'];

                Map<String, dynamic> map = e['users'];
                return Task(
                  // sharedBy: snapshot.data!.docs[i]['sharedBy'],
                  id: e.id,
                  name: e['name'],
                  startTime: e['startTime'],
                  endTime: e['endTime'].toDate(),
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
              finishedTasks =
                  tasks.where((element) => element.status == true).toList();
              unFinishedTasks =
                  tasks.where((element) => element.status == false).toList();
            }
            return TabBarView(
              children: [
                unFinishedTasks.isEmpty
                    ? Center(
                        child: Text('لا يوجد مهام غير منجزة'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                            itemBuilder: (context, i) {
                              return ListTile(
                                trailing: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                leading: CircularPercentIndicator(
                                    radius: 50,
                                    lineWidth: 5.0,
                                    percent: snapshot.data!.docs[i]
                                            ['percentage'] /
                                        100,
                                    center: Text(
                                        "${(snapshot.data!.docs[i]['percentage'])} %"),
                                    progressColor: Colors.red),
                                title: Text(
                                  unFinishedTasks[i].name!,
                                  textAlign: TextAlign.right,
                                ),
                                subtitle: Text(
                                  intl.DateFormat('y/M/dd').format(
                                      unFinishedTasks[i].startTime!.toDate()),
                                  textAlign: TextAlign.right,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TestAddEditScreen(
                                                task: unFinishedTasks[i],
                                                isAdmin: true,
                                              )));
                                },
                              );
                            },
                            separatorBuilder: (context, i) => Divider(),
                            itemCount: unFinishedTasks.length),
                      ),
                finishedTasks.isEmpty
                    ? Center(
                        child: Text('لا يوجد مهام منجزة'),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.separated(
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: CircularPercentIndicator(
                                    radius: 50,
                                    lineWidth: 5.0,
                                    percent: snapshot.data!.docs[i]
                                            ['percentage'] /
                                        100,
                                    center: Text(
                                        "${(snapshot.data!.docs[i]['percentage'])} %"),
                                    progressColor: Colors.green),
                                trailing: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                title: Text(
                                  finishedTasks[i].name!,
                                  textAlign: TextAlign.right,
                                ),
                                subtitle: Text(
                                  intl.DateFormat('y/M/dd').format(
                                      finishedTasks[i].startTime!.toDate()),
                                  textAlign: TextAlign.right,
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TestAddEditScreen(
                                                task: finishedTasks[i],
                                                isAdmin: true,
                                              )));
                                },
                              );
                            },
                            separatorBuilder: (context, i) => Divider(),
                            itemCount: finishedTasks.length),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
