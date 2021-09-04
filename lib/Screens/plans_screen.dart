import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:plansmanager/Screens/home_screen.dart';
import 'package:plansmanager/main.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:provider/provider.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatefulWidget {
  static final routeName = 'PlansScreen';

  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _monthController = TextEditingController();
  bool _isLoading = false;
  bool _duplicate = false;
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
    context.read<Plan>().getCurrentPlan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
    // const curveHeight = 50.0;

    return Scaffold(
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
          return snapshot.data!.docs.isNotEmpty
              ? ListView.builder(
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
                            title: Text(
                              snapshot.data!.docs[i]['name'],
                              style: TextStyle(
                                  textBaseline: TextBaseline.ideographic),
                            ),
                            trailing: CircularPercentIndicator(
                                animation: true,
                                animateFromLastPercent: true,
                                radius: 50,
                                lineWidth: 5.0,
                                percent: snapshot.data!.docs[i]['percentage'],
                                center: Text(
                                    "${(snapshot.data!.docs[i]['percentage'] * 100).toInt()} %"),
                                progressColor: Colors.green),
                            subtitle: Text(
                                '01/${snapshot.data!.docs[i]['month']}/2021'),

                            onTap: () async {
                              int? month =
                                  await snapshot.data!.docs[i]['month'];
                              HomeScreen.initialMonth =
                                  month == null ? month : month - 1;
                              //  MyApp.pageController.jumpToPage(1);
                              if (month != null) {
                                context.read<Plan>().getCustomPlan(month);
                              }
                            },

                            // data[i]['endDate'].to

                            // subtitle: Text(
                            //     'خطة شهر ${snapshot.data!.docs[i]['month']}'),
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance.collection('plans').add({
                          'month': DateTime.now().month,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'name': 'شهر ${DateTime.now().month}',
                          'percentage': 0.0,
                        });
                        context.read()<Plan>().getCurrentPlan();
                      },
                      child: Text('إضافة خطة هذا الشهر'),
                    ),
                  ),
                );
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
            child: Text('أضف خطة جديدة'),
            style:
                ElevatedButton.styleFrom(elevation: 5, primary: Colors.purple),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: 'اسم الخطة',
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'أدخل اسم';
                                    }
                                    if (value.isEmpty) {
                                      return 'أدخل اسم للخطة';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  controller: _monthController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'الشهر',
                                  ),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'أدخل رقم الشهر';
                                    }
                                    if (value.isEmpty) {
                                      return 'ادخل رقم صحيح';
                                    }
                                    if (_duplicate) {
                                      return 'خطة هذا الشهر موجودة من قبل';
                                    }
                                    if (int.parse(value) < 0 ||
                                        int.parse(value) > 12) {
                                      return 'ادخل رقم صحيح';
                                    }
                                    _duplicate = true;
                                  },
                                ),
                              ),
                              _isLoading
                                  ? LoadingIndicator(
                                      indicatorType: Indicator.orbit,
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            int month = int.parse(
                                                _monthController.text);
                                            //  String name = _nameController.text;
                                            var ref = FirebaseFirestore.instance
                                                .collection('plans');
                                            var d = await ref
                                                .where('userId',
                                                    isEqualTo: FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid)
                                                .where('month',
                                                    isEqualTo: month)
                                                .get();
                                            if (d.docs.isNotEmpty) {
                                              _duplicate = true;
                                              _formKey.currentState!.validate();
                                            } else {
                                              await ref.add({
                                                'month': int.parse(
                                                    _monthController.text),
                                                'userId': FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                'name': _nameController.text,
                                                'percentage': 0.0,
                                              });
                                              _duplicate = false;
                                              context
                                                  .read<Plan>()
                                                  .getCurrentPlan();
                                              Navigator.of(context).pop();
                                            }
                                          }
                                        } catch (error) {
                                          print(error);
                                        }
                                      },
                                      child: Text('إضافة'))
                            ],
                          )),
                    );
                  });
            }),
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
