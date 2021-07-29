import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:plansmanager/Screens/add_new_task.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/Screens/plans_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    String? current = Provider.of<Plan>(context, listen: true).current;
    print('$current currrent');
    bool _isSelected = false;
    return Scaffold(
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
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                header: Container(color: Colors.white, child: TasksCalendar()),
                sticky: true,
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(
                        color: Colors.white,
                        //margin: EdgeInsets.only(right: 20,bottom: 5),
                        padding: EdgeInsets.only(bottom: 10, right: 10),
                        child: Text(
                          current == null ? '' : '',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )),
                    Consumer<Plan>(
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
                            : ListView.builder(
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
        backgroundColor: Colors.white);
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
