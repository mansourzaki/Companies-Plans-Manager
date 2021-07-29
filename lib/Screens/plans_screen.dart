import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/widgets/plans_calendar.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:loading_indicator/loading_indicator.dart';

class PlansScreen extends StatefulWidget {
  static final routeName = 'PlansScreen';

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen>
    with AutomaticKeepAliveClientMixin {
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
    print('hi from planss');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
    // const curveHeight = 50.0;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(' الخطط الشهرية'),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //         onPressed: () {
      //           FirebaseAuth.instance.signOut();
      //           context.read<Plan>().clearAllTasks();
      //           context.read<Plan>().clearCurrent();
      //           Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
      //         },
      //         icon: Icon(Icons.exit_to_app))
      //   ],
      //   // shape: RoundedRectangleBorder(
      //   //   borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      //   // )
      // ),
      drawer: Drawer(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     try {
      //       await context.read<Plan>().addPlanNewVersion('شهر 7', 7);
      //     } catch (error) {
      //       print(error);
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader(
            header: Container(
              child: PlansCalendar(),
              color: Colors.white,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('plans')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingIndicator(
                            indicatorType: Indicator.circleStrokeSpin),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          child: Dismissible(
                            key: Key(snapshot.data!.docs[i]['name']),
                            onDismissed: (direction) {
                              setState(() {
                                snapshot.data!.docs[i].reference.delete();
                              });
                            },
                            background: Card(
                              color: Colors.red,
                            ),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.amber[400],
                              ),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text(snapshot.data!.docs[i]['name']),
                                leading: Icon(Icons.task),

                                onTap: () {},
                                // data[i]['endDate'].to

                                // subtitle: Text(
                                //     'خطة شهر ${snapshot.data!.docs[i]['month']}'),
                              ),
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

  @override
  bool get wantKeepAlive => true;
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
