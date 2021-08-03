import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plansmanager/Screens/add_new_task.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/widgets/task_card.dart';
import '../provider/task.dart';
import 'package:plansmanager/widgets/tasks_calendar.dart';
import 'package:provider/provider.dart';

final List<String> labels = ['موبايل', 'انظمة'];
enum TaskType { support, dev }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static final routeName = 'HomeScreen';
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
  int? _selectedIndex = null;
  @override
  void initState() {
    // context.read<Plan>().getPlans(month: DateTime.now().month);
    // context.read<Plan>().getCurrentMonthTasks();
    // context.read<Plan>().getCurrentDayTasks();
    // print('hi from init state');
    context.read<Plan>().getCurrentPlan();
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
                  MaterialPageRoute(builder: (context) => AddNewTask()));
            }
          },
          child: Icon(Icons.add),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
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
                              // context
                              //     .read<Plan>()
                              //     .getAllTasks(_months[i], stay: true);
                              setState(() {
                                _selectedIndex = i;
                                _isSelected = !_isSelected;
                              });
                              print(i + 1);
                              context
                                  .read<Plan>()
                                  .setTasksBasedOnSelectedMonth(i + 1);
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
                                      : Colors.blue[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                _months[i],
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: CircleAvatar(
                                      radius: 10,
                                      child: Text('$alert'),
                                    ),
                                  )),
                              TextSpan(
                                text: 'المهام المُشتركة',
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(color: Colors.black)),
                              ),
                            ],
                          )),
                          icon: Icon(
                            Icons.share_sharp,
                            color: Colors.amber,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'مهام اليوم',
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
              body: Consumer<Plan>(
                builder: (context, plan, child) {
                  return plan.allTasks.isEmpty
                      ? Center(
                          child: LoadingIndicator(
                          indicatorType: Indicator.ballGridPulse,
                          colors: [
                            Colors.amber,
                            Colors.amber[300] ?? Colors.red,
                            Colors.blue,
                            Colors.blueGrey,
                            Colors.red
                          ],
                        ))
                      : TabBarView(children: [
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('plans')
                                .doc(current)
                                .collection('tasks')
                                .where('shared', isEqualTo: true)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data == null ||
                                  snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                return Text('loading');
                              }
                              alert = snapshot.data!.docs.length;
                              print('alerts ${snapshot.data!.docs.length}');

                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, i) {
                                  Task task = Task(
                                      id: snapshot.data!.docs[i].id,
                                      name: snapshot.data!.docs[i]['name'],
                                      startTime: snapshot.data!.docs[i]
                                          ['startTime'],
                                      endTime: DateTime.now(),
                                      status: snapshot.data!.docs[i]['status'],
                                      workHours: snapshot.data!.docs[i]
                                          ['workHours'],
                                      teams: snapshot.data!.docs[i]['teams'],
                                      type: snapshot.data!.docs[i]['type'],
                                      ach: snapshot.data!.docs[i]['ach'],
                                      shared: snapshot.data!.docs[i]['shared'],
                                      percentage: snapshot.data!.docs[i]
                                          ['percentage'],
                                      notes: snapshot.data!.docs[i]['notes']);
                                  // Task task = Task(
                                  //     id: plan.sharedTasks![i].id,
                                  //     name: plan.sharedTasks![i].name,
                                  //     startTime: plan.sharedTasks![i].startTime,
                                  //     endTime: plan.sharedTasks![i].endTime,
                                  //     status: plan.sharedTasks![i].status,
                                  //     workHours: plan.sharedTasks![i].workHours,
                                  //     teams: plan.sharedTasks![i].teams,
                                  //     type: plan.sharedTasks![i].type,
                                  //     ach: plan.sharedTasks![i].ach,
                                  //     shared: plan.sharedTasks![i].shared,
                                  //     percentage:
                                  //         plan.sharedTasks![i].percentage,
                                  //     notes: plan.sharedTasks![i].notes);
                                  return TaskCard(
                                    task: task,
                                    id: current,
                                  );
                                },
                              );
                            },
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plan.tasks!.length,
                              itemBuilder: (context, i) {
                                Task task = Task(
                                    id: plan.tasks![i].id,
                                    name: plan.tasks![i].name,
                                    startTime: plan.tasks![i].startTime,
                                    endTime: plan.tasks![i].endTime,
                                    status: plan.tasks![i].status,
                                    workHours: plan.tasks![i].workHours,
                                    teams: plan.tasks![i].teams,
                                    type: plan.tasks![i].type,
                                    ach: plan.tasks![i].ach,
                                    percentage: plan.tasks![i].percentage,
                                    notes: plan.tasks![i].notes);
                                return TaskCard(
                                  task: task,
                                  id: current,
                                );
                              }),
                        ]);
                },
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
