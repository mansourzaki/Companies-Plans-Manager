import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/widgets/plans_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class PlansScreen extends StatefulWidget {
  static final routeName = 'PlansScreen';

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  // List _months = [
  //   'January',
  //   'February',
  //   'March',
  //   'April',
  //   'May',
  //   'June',
  //   'July',
  //   'August',
  //   'September',
  //   'October',
  //   'November',
  //   'December'
  // ];
  @override
  void initState() {
    context.read<Plan>().getPlans();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
   // const curveHeight = 50.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(' الخطط الشهرية'),
        centerTitle: true,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        // )
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // context.read<Plan>().addNewPlan(
          //       Plan(
          //         name: 'خطة جديدة',
          //         startDate: Timestamp.fromDate(DateTime(2021, 7)),
          //         tasks: [Task(name: 'plan 1'), Task(name: 'Plan 2')],
          //         teamName: 'anything',
          //         endDate: Timestamp.fromDate(DateTime(2021, 9)),
          //       ),
          //     );
          //    context.read<Plan>().plansBasedOnMonth(7);
        },
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Container(
              child: PlansCalendar(),
              color: Colors.white,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Consumer<Plan>(
                  builder: (context, plan, child) {
                    if (plan.plans.length == 0) {
                      return Center(
                        child: Text('No Data Found'),
                      );
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: plan.plans.length,
                      itemBuilder: (context, i) {
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
                              title: Text(plan.plans[i].name!),
                              leading: Icon(Icons.task),

                              onTap: () {},
                              // data[i]['endDate'].to

                              subtitle: Text(
                                  '${intl.DateFormat('y/M/d').format(plan.plans[i].startDate!.toDate())} - ${intl.DateFormat('y/M/d').format(plan.plans[i].endDate!.toDate())}'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
                //   },
                //  ),
                // )
                // },
                // ),
              ]),
            ),
          ),
          // SliverAppBar(
          //   pinned: true,
          //   expandedHeight: 200,
          //   leading: Container(),
          //   backgroundColor: Colors.white,
          //   flexibleSpace: Calendar(),
          //   collapsedHeight: 150,
          // ),
          // SliverPersistentHeader(
          //   delegate: PersistentHeader(
          //     MonthsListView(months: _months),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class MonthsListView extends StatelessWidget {
  const MonthsListView({
    Key? key,
    required List months,
  })  : _months = months,
        super(key: key);

  final List _months;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _months.length,
        itemBuilder: (context, i) {
          return Container(
            width: 100,
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(vertical: 25, horizontal: 12),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.amber[300]),
            child: Text(_months[i]),
          );
        });
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);
  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
// class PersistentHeader extends SliverPersistentHeaderDelegate {
//   final Widget widget;
//   PersistentHeader(this.widget);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       child: Container(
//         color: Colors.white,
//         child: Center(child: widget),
//       ),
//     );
//   }

//   @override
//   double get maxExtent => 150;

//   @override
//   double get minExtent => 150;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }
