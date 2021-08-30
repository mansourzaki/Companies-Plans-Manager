import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/Screens/Test_add_edit_task.dart';
import '../provider/task.dart';
import 'package:provider/provider.dart';
import '../provider/plan.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:intl/intl.dart' as intl;

class TaskCard extends StatefulWidget {
  TaskCard({@required this.task, @required this.id, this.name = ''});
  final Task? task;
  final String? id;
  final String name;
  // String id;
  // String name;
  // Timestamp date;
  // bool status;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isLoading = false;

  @override
  void initState() {
    context.read<Task>().getTaskOwner(widget.task!.sharedBy!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<Task>().getTaskOwner(widget.task!.sharedBy!);
    final pl = context.read<Plan>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        //padding: EdgeInsets.symmetric(vertical: 18),
        constraints: BoxConstraints(minHeight: 150, minWidth: 366),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

          // gradient: widget.task!.shared
          //     ? LinearGradient(colors: [
          //         Colors.purple[100]!,
          //         Colors.purple[200]!,
          //         Colors.purple[300]!
          //       ], begin: Alignment.topLeft, end: Alignment.bottomRight)
          //     : LinearGradient(colors: [
          //         Colors.amber[200]!,
          //         Colors.amber[300]!,
          //         Colors.amber[500]!
          //       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          //  color: widget.task!.shared ? Colors.purple[300] : Colors.amber[400],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, right: 20, bottom: 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  intl.DateFormat.yMMMd()
                      .format(widget.task!.startTime!.toDate()),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 30,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestAddEditScreen(
                              task: widget.task,
                            )));
              },
              horizontalTitleGap: 0,
              minLeadingWidth: 30,
              title: Text(
                widget.task!.name!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: widget.task!.status!
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              subtitle: Text(
                widget.task!.notes!,
                style: TextStyle(
                    decoration: widget.task!.status!
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
              leading: Container(
                width: 2,
                color: widget.task!.shared ? Colors.purple : Colors.orange,
              ),
              trailing: _isLoading
                  ? Container(
                      width: 35,
                      height: 40,
                      child: Center(
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballClipRotatePulse,
                        ),
                      ),
                    )
                  : Checkbox(
                      activeColor: Colors.orange,
                      value: widget.task!.status,
                      onChanged: widget.task!.sharedBy ==
                              FirebaseAuth.instance.currentUser!.uid
                          ? (value) async {
                              setState(() {
                                _isLoading = true;
                              });
                              widget.task!.status = value;
                              _isLoading = false;
                              await pl.updateTaskSatus(widget.task!, value!);
                              setState(() async {
                                print('${widget.task!.id} task id');
                                // widget.task!.status = value;
                                // _isLoading = false;
                              });
                              Future.delayed(Duration(seconds: 2), () async {});
                            }
                          : null),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.timelapse,
                        color: Color(0xffB2BAC9),
                      ),
                      Text(
                        intl.DateFormat(' kk:mm a')
                            .format(widget.task!.startTime!.toDate()),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.people,
                        color: Color(0xffB2BAC9),
                      ),
                      Text('  ${widget.task!.users!.length}'),
                      SizedBox(
                        width: 60,
                      ),
                      widget.task!.shared
                          ? Row(
                              children: [
                                Icon(
                                  Icons.share,
                                  color: Color(0xffB2BAC9),
                                ),
                                Text(context.watch<Task>().ownerName ?? 'ss')
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
