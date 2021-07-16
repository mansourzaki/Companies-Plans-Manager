import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/tasks.dart';
import 'package:plansmanager/widgets/calendar.dart';
import 'package:plansmanager/widgets/planCard.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatefulWidget {
  static final routeName = 'PlansScreen';

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
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

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      //appBar: AppBar(),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          context.read<Plan>().getPlans();
        },
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
          ),
          SliverStickyHeader(
            header: Container(
              child: Calendar(),
              color: Colors.white,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                FutureBuilder(
                  future: FirebaseFirestore.instance.collection('plans').get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text('NOo Data'),
                      );
                    }
                    List data =
                        snapshot.data!.docs.map((e) => e.data()).toList();

                    print(data);
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, i) {
                        return Directionality(
                          textDirection: TextDirection.rtl,
                          // child: PlanCard(
                          //     name: tasksList[i].name,
                          //     startDate: tasksList[i].startDate,
                          //     endDate: tasksList[i].endDate,
                          //     teamName: tasksList[i].teamName),

                          child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.amber[400],
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              title: Text(data[i]['name']),
                              leading: Icon(Icons.task),
                              onTap: () {},
                              // data[i]['endDate'].to
                              subtitle: Text('' + ' - ' + ''),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
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
