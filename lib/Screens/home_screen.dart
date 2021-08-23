import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:plansmanager/Screens/Test_add_edit_task.dart';

import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/task.dart';
import '../provider/user.dart' as user;
import 'package:plansmanager/widgets/task_card.dart';

import 'package:plansmanager/widgets/tasks_calendar.dart';
import 'package:provider/provider.dart';

final List<String> labels = ['موبايل', 'انظمة'];
enum TaskType { support, dev }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final routeName = 'HomeScreen';
  static bool allmonth = false;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  List _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<Stream> streams = [];
  // Map _mon = {
  //   1: 'January',
  //   2: 'February',
  //   3: 'March',
  //   4: 'April',
  //   5: 'May',
  //   6: 'June',
  //   7: 'July',
  //   8: 'August',
  //   9: 'September',
  // };
  int? _selectedIndex;
  @override
  void initState() {
    // context.read<Plan>().getPlans(month: DateTime.now().month);
    // context.read<Plan>().getCurrentMonthTasks();
    // context.read<Plan>().getCurrentDayTasks();
    // print('hi from init state');
    context.read<Plan>().getCurrentPlan();
    context.read<Plan>().getSharedTasks(DateTime.now().month);
    context.read<Plan>().getAllTasks(DateTime.now().month);

    print('init ${FirebaseAuth.instance.currentUser!.uid}');
    //context.read<Plan>().setTasksBasedOnSelectedDay(DateTime.now().day);
    super.initState();
  }

  TaskType taskType = TaskType.dev;
  int? alert;
  @override
  Widget build(BuildContext context) {
    String? current = Provider.of<Plan>(context, listen: true).current;
    print('$current currrent');

    bool _isSelected = false;
    // List<DocumentSnapshot>? _docs = [];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (current == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('لا يوجد خطة حالية'),
                    backgroundColor: Colors.red),
              );
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TestAddEditScreen()));
            }
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                print('in ref');
                context.read<Plan>().getCurrentPlan();
                TasksCalendar().setDayForToday();
              });
              await context.read<Plan>().getAllTasks(7);
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, bool c) {
                return [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 12,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = i;
                                  _isSelected = !_isSelected;
                                  HomeScreen.allmonth = true;
                                });
                                print(i + 1);
                                context.read<Plan>().getCustomPlan(i + 1);
                                // context
                                //     .read<Plan>()
                                //     .setTasksBasedOnSelectedMonth(i + 1);
                              },
                              child: Container(
                                width: 85,
                                alignment: Alignment.topCenter,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                    color: (_selectedIndex == i &&
                                            _selectedIndex != null)
                                        ? Colors.amber
                                        : Colors.red[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  _months[i],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  // SliverStickyHeader(
                  //   header:
                  //       Text(FirebaseAuth.instance.currentUser!.displayName!),
                  // ),
                  SliverStickyHeader(
                    header:
                        Container(color: Colors.white, child: TasksCalendar()),
                    sticky: true,
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      TabBar(tabs: [
                        Tab(
                          child: RichText(
                              text: TextSpan(
                            children: [
                              // WidgetSpan(
                              //     alignment: PlaceholderAlignment.middle,
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 10),
                              //       child: CircleAvatar(
                              //         radius: 10,
                              //         child: Text('$alert'),
                              //       ),
                              //     )),
                              TextSpan(
                                text: 'المهام المُشتركة',
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(color: Colors.black)),
                              ),
                            ],
                          )),
                          icon: Icon(
                            Icons.share_sharp,
                            color: Colors.purple[300],
                          ),
                        ),
                        Tab(
                          child: Text(
                            'المهام',
                            style: TextStyle(color: Colors.black),
                          ),
                          icon: Icon(
                            Icons.task,
                            color: Colors.amber,
                          ),
                        ),
                      ])
                    ])),
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('sharedTasks')
                          .where('recieversId',
                              arrayContains:
                                  FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
                        // if (snapshot1.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return Center(
                        //       child: LoadingIndicator(
                        //           indicatorType: Indicator.ballGridPulse));
                        // }
                        if (snapshot1.data == null) {
                          return Center();
                        }

                        return snapshot1.data!.docs.isEmpty
                            ? Center(child: Text('No shared tasks'))
                            : StreamBuilder(builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot2) {
                                if (snapshot2.hasError) {
                                  return Text('Something went wrong');
                                }

                                // if (snapshot2.connectionState ==
                                //     ConnectionState.waiting) {
                                //   return Center(
                                //       child: LoadingIndicator(
                                //           indicatorType:
                                //               Indicator.ballGridPulse));
                                // }
                                Set ids = {};

                                /// Set planIds = {};
                                List<Stream<QuerySnapshot>> s =
                                    snapshot1.data!.docs.map((e) {
                                  print('looop ${e['planId']}');
                                  ids.add(e['taskId']);
                                  // planIds.add(e['planId']);
                                  return FirebaseFirestore.instance
                                      .collection('plans')
                                      .doc(e['planId'])
                                      .collection('tasks')
                                      .snapshots();
                                }).toList();
                                Stream<QuerySnapshot> stream =
                                    StreamGroup.merge(s);
                                // s.forEach((element) {
                                //   element.concatWith(s);
                                // });
                                return StreamBuilder(
                                  stream: stream,
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    List<Task> tasks = [];
                                    List<Task> selectedDayTasks = [];
                                    if (snapshot.data == null) {
                                      return Center();
                                    }

                                    if (current != null &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      tasks = snapshot.data!.docs
                                          .where((element) =>
                                              ids.contains(element.id))
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
                                          users: map.entries
                                              .map((e) =>
                                                  user.User(e.key, e.value))
                                              .toList(),
                                        );
                                      }).toList();
                                      selectedDayTasks = tasks
                                          .where((element) => (element
                                                      .startTime!
                                                      .toDate()
                                                      .year ==
                                                  TasksCalendar().day.year &&
                                              element.startTime!
                                                      .toDate()
                                                      .month ==
                                                  TasksCalendar().day.month &&
                                              element.startTime!.toDate().day ==
                                                  TasksCalendar().day.day))
                                          .toList();
                                    }
                                    return HomeScreen.allmonth
                                        ? ListView.builder(
                                            itemCount: tasks.length,
                                            itemBuilder: (context, i) {
                                              return tasks.length == 0
                                                  ? Text('No Tasks For Today')
                                                  : TaskCard(
                                                      task: tasks[i],
                                                      id: tasks[i].id);
                                            })
                                        : ListView.builder(
                                            itemCount: selectedDayTasks.length,
                                            itemBuilder: (context, i) {
                                              return selectedDayTasks.length ==
                                                      0
                                                  ? Text('No Tasks For Today')
                                                  : TaskCard(
                                                      task: selectedDayTasks[i],
                                                      id: selectedDayTasks[i]
                                                          .id);
                                            });
                                  },
                                );
                              });
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('plans')
                          .doc(current)
                          .collection('tasks')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshot.data == null) {
                          return Center();
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballGridPulse,colors: [
                                  Colors.amber,Colors.red,Colors.blue
                                ],),
                          );
                        }
                        List<Task> tasks = [];
                        List<Task> selectedDayTasks = [];
                        // if (snapshot.data == null) {
                        //   return Center();
                        // }
                        if (current != null && snapshot.data!.docs.isNotEmpty) {
                          tasks = snapshot.data!.docs.map((e) {
                            Timestamp t = e['endTime'];
                            Map<String, dynamic> map = e['users'];
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
                              users: map.entries
                                  .map((e) => user.User(e.key, e.value))
                                  .toList(),
                            );
                          }).toList();
                          selectedDayTasks = tasks
                              .where((element) =>
                                  (element.startTime!.toDate().year ==
                                          TasksCalendar().day.year &&
                                      element.startTime!.toDate().month ==
                                          TasksCalendar().day.month &&
                                      element.startTime!.toDate().day ==
                                          TasksCalendar().day.day))
                              .toList();
                        }
                        // if (HomeScreen.allmonth = true) {
                        //   return ListView.builder(
                        //       itemCount: tasks.length,
                        //       itemBuilder: (context, i) {
                        //         return tasks.length == 0
                        //             ? Text('No Tasks For Today')
                        //             : TaskCard(task: tasks[i], id: tasks[i].id);
                        //       });
                        // }

                        return HomeScreen.allmonth
                            ? ListView.builder(
                                itemCount: tasks.length,
                                itemBuilder: (context, i) {
                                  return tasks.length == 0
                                      ? Text('No Tasks For Today')
                                      : TaskCard(
                                          task: tasks[i], id: tasks[i].id);
                                })
                            : ListView.builder(
                                itemCount: selectedDayTasks.length,
                                itemBuilder: (context, i) {
                                  return selectedDayTasks.length == 0
                                      ? Text('No Tasks For Today')
                                      : TaskCard(
                                          task: selectedDayTasks[i],
                                          id: selectedDayTasks[i].id);
                                });
                      })
                ],
              ),

              //slivers: [
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     width: 200,
              //     height: 50,
              //     child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 12,
              //       itemBuilder: (context, i) {
              //         return GestureDetector(
              //           onTap: () {
              //             // context
              //             //     .read<Plan>()
              //             //     .getAllTasks(_months[i], stay: true);
              //             setState(() {
              //               _selectedIndex = i;
              //               _isSelected = !_isSelected;
              //             });
              //             print(i + 1);
              //             context
              //                 .read<Plan>()
              //                 .setTasksBasedOnSelectedMonth(i + 1);
              //           },
              //           child: Container(
              //             width: 85,
              //             alignment: Alignment.topCenter,
              //             padding:
              //                 EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              //             margin: EdgeInsets.symmetric(
              //                 vertical: 10, horizontal: 15),
              //             decoration: BoxDecoration(
              //                 color: (_selectedIndex == i &&
              //                         _selectedIndex != null)
              //                     ? Colors.amber
              //                     : Colors.blue[300],
              //                 borderRadius: BorderRadius.circular(10)),
              //             child: Text(
              //               _months[i],
              //               style: const TextStyle(color: Colors.black),
              //             ),
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              // SliverStickyHeader(
              //   header: Container(color: Colors.white, child: TasksCalendar()),
              //   sticky: true,
              //   sliver: SliverList(
              //     delegate: SliverChildListDelegate([
              // DefaultTabController(
              //   initialIndex: 1,
              //   length: 2,
              //   child: TabBar(tabs: [
              //     Tab(
              //       text: 'المهام المُشاركة',
              //       icon: Icon(
              //         Icons.share_sharp,
              //         color: Colors.amber,
              //       ),
              //     ),
              //     Tab(
              //       child: Text(
              //         'مهام اليوم',
              //         style: TextStyle(color: Colors.black),
              //       ),
              //       icon: Icon(
              //         Icons.task,
              //         color: Colors.amber,
              //       ),
              //     ),
              //   ]),
              // ),

              // Consumer<Plan>(
              //   builder: (context, plan, child) {
              //     return plan.allTasks.isEmpty
              //         ? Center(
              //             child: LoadingIndicator(
              //             indicatorType: Indicator.ballGridPulse,
              //             colors: [
              //               Colors.amber,
              //               Colors.amber[300] ?? Colors.red,
              //               Colors.blue,
              //               Colors.blueGrey,
              //               Colors.red
              //             ],
              //           ))
              //         : ListView.builder(
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             itemCount: plan.tasks!.length,
              //             itemBuilder: (context, i) {
              //               Task task = Task(
              //                   id: plan.tasks![i].id,
              //                   name: plan.tasks![i].name,
              //                   startTime: plan.tasks![i].startTime,
              //                   endTime: plan.tasks![i].endTime,
              //                   status: plan.tasks![i].status,
              //                   workHours: plan.tasks![i].workHours,
              //                   teams: plan.tasks![i].teams,
              //                   type: plan.tasks![i].type,
              //                   ach: plan.tasks![i].ach,
              //                   percentage: plan.tasks![i].percentage,
              //                   notes: plan.tasks![i].notes);
              //               return TaskCard(
              //                 task: task,
              //                 id: current,
              //               );
              //             },
              //           );
              //   },
              // ),
            )
            // ],
            ),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;
  PersistentHeader(this.widget);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: widget,
    );
  }

  @override
  double get maxExtent => 340;

  @override
  double get minExtent => 150;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
