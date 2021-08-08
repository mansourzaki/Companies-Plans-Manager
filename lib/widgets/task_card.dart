import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/Screens/Test_add_edit_task.dart';
import 'package:plansmanager/Screens/edit_task.dart';
import '../provider/task.dart';
import 'package:provider/provider.dart';
import '../provider/plan.dart';
import 'package:loading_indicator/loading_indicator.dart';

class TaskCard extends StatefulWidget {
  TaskCard({@required this.task, @required this.id});
  final Task? task;
  final String? id;
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
  Widget build(BuildContext context) {
    final pl = context.read<Plan>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: widget.task!.shared
              ? LinearGradient(colors: [
                  Colors.purple[100]!,
                  Colors.purple[200]!,
                  Colors.purple[300]!
                ], begin: Alignment.topLeft, end: Alignment.bottomRight)
              : LinearGradient(colors: [
                  Colors.amber[200]!,
                  Colors.amber[300]!,
                  Colors.amber[500]!
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          //  color: widget.task!.shared ? Colors.purple[300] : Colors.amber[400],
        ),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            widget.task!.name!,
            style: TextStyle(
                decoration: widget.task!.status!
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
          leading: _isLoading
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
                  value: widget.task!.status,
                  onChanged: (value) async {
                    setState(() {
                      _isLoading = true;
                    });
                    await pl.updateTaskSatus(widget.task!, value!);
                    setState(() {
                      print('${widget.task!.id} task id');
                      widget.task!.status = value;
                      _isLoading = false;
                    });
                    Future.delayed(Duration(seconds: 2), () async {});
                  }),
          // trailing: IconButton(
          //   // focusColor: Colors.red,
          //   splashColor: Colors.red,
          //   highlightColor: Colors.red,
          //   icon: Icon(Icons.share),
          //   onPressed: () {},
          // ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TestAddEditScreen(
                          task: widget.task,
                        )));
          },
          subtitle: Text(
            intl.DateFormat.yMMMMd().format(widget.task!.startTime!.toDate()),
            style: TextStyle(
                decoration: widget.task!.status!
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ),
      ),
    );
  }
}
