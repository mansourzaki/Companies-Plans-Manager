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
      //       await FirebaseFirestore.instance.collection('teams').add({
      //         'A': 'A فريق برمجة',
      //         'B': 'B فريق برمجة',
      //         'C': 'C فريق برمجة',
      //         'D': 'D فريق برمجة',
      //         'E': 'E فريق برمجة',
      //         'F': 'F فريق قواعد بيانات',
      //         'G': 'G فريق أمن المواقع',
      //         'H': 'H فريقأمن المواقع',
      //         'I': 'I فريق أنظمة التشغيل',
      //         'J': 'J فريق إدارة الشبكات',
      //         'K': 'K فريق التصميم والمونتاج',
      //         'L': 'L فريق تطبيقات الهواتف',
      //         'M': 'M فريق الصيانة',
      //       });
      //       // await context.read<Plan>().addPlanNewVersion('شهر 7', 7);
      //     } catch (error) {
      //       print(error);
      //     }
      //   },
      //   child: Icon(Icons.add),
      // ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('plans')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child:
                  LoadingIndicator(indicatorType: Indicator.circleStrokeSpin),
            );
          }
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          return snapshot.data!.docs.isEmpty
              ? Center(
                  child: ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('plans').add({
                          'month': DateTime.now().month,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'name': '${DateTime.now().month} خطة شهر'
                        });
                      },
                      child: Text('Add this month plan')),
                )
              : ListView.builder(
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
