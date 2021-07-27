import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/Screens/add_new_task.dart';
import 'package:plansmanager/Screens/login_screen.dart';
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

class _HomeScreenState extends State<HomeScreen> {
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

  @override
  Widget build(BuildContext context) {
    String? current = Provider.of<Plan>(context, listen: true).current;
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.read<Plan>().clearAllTasks();
                context.read<Plan>().clearCurrent();
                Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (current == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('لا يوجد خطة حالية'),
                  backgroundColor: Colors.red),
            );
          } else {
            Navigator.pushNamed(context, AddNewTask.routeName);
          }
          // context.read<Plan>().addPlan(
          //     Plan(
          //       name: 'خطة شهر 7',
          //       startDate: Timestamp.fromDate(DateTime(2021, 8)),
          //       endDate: Timestamp.fromDate(DateTime(2021, 8)),
          //       teamName: 'any',
          //     ),
          //     8,
          //     context);

          // context.read<Plan>().addTask(
          //       Task(
          //           name: 'خطة شهر 8 رقم 2',
          //           startTime: Timestamp.fromDate(DateTime(2021, 8, 27)),
          //           endTime: DateTime(2021, 8, 27),
          //           status: false),
          //       8,
          //     );
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
        child: CustomScrollView(
          slivers: [
            SliverStickyHeader(
              header: Container(color: Colors.white, child: TasksCalendar()),
              sticky: true,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                      color: Colors.white,
                      //margin: EdgeInsets.only(right: 20,bottom: 5),
                      padding: EdgeInsets.only(bottom: 10, right: 10),
                      child: Text(
                        current == null ? 'لا يوجد خطة' : '',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                  Consumer<Plan>(
                    builder: (context, plan, child) {
                      return plan.allTasks.isEmpty
                          ? Center(child: Text('No Tasks Found'))
                          : ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: plan.tasks!.length,
                              itemBuilder: (context, i) {
                                print('before build $current');
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
                              },
                            );
                    },
                  ),
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
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
