import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plansmanager/Screens/add_new_task.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/provider/plan.dart';
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
    context.read<Plan>().getCurrentDayTasks();
    print('hi from init state');
    super.initState();
  }

  TaskType taskType = TaskType.dev;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الرئيسية'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          print(context.read<Plan>().getPlansNewVerison(7));
          // context.read<Plan>().addPlan(
          //     Plan(
          //       name: 'خطة شهر 8',
          //       startDate: Timestamp.fromDate(DateTime(2021, 8)),
          //       endDate: Timestamp.fromDate(DateTime(2021, 8)),
          //       teamName: 'any',
          //     ),
          //     9,
          //     context);

          context.read<Plan>().addTask(
                Task(
                    name: 'خطة شهر 7',
                    startTime: Timestamp.fromDate(DateTime(2021, 7, 28)),
                    endTime: DateTime(2021, 7, 28),
                    status: false),
                7,
              );

          //Navigator.pushNamed(context, AddNewTask.routeName);
        },
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: TasksCalendar(),
            sticky: true,
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Consumer<Plan>(
                  builder: (context, plan, child) {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: plan.todaysTasks.length,
                      itemBuilder: (context, i) {
                        List<Task> tasks = plan.todaysTasks;
                        if (tasks.length == 0) {
                          print('cant find tasks');
                          return Text('No Tasks For Today');
                        }
                        print(
                            '${plan.todaysTasks[0].name} + this is task name');

                        return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber[400],
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(tasks[i].name ?? ''),
                                leading: Icon(Icons.task),

                                onTap: () {},
                                // data[i]['endDate'].to

                                subtitle: Text('d'),
                              ),
                            ));
                      },
                    );
                  },
                ),
              ]),
            ),
          )
        ],
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
