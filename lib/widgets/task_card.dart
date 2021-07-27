import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/Screens/edit_task.dart';
import '../provider/task.dart';
import 'package:provider/provider.dart';
import '../provider/plan.dart';

class TaskCard extends StatefulWidget {
  TaskCard({@required this.task, @required this.id});
  Task? task;
  String? id;
  // String id;
  // String name;
  // Timestamp date;
  // bool status;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    final pl = context.read<Plan>();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amber[400],
          ),
          child: ListTile(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(widget.task!.name!),
            leading: Checkbox(
                value: widget.task!.status,
                onChanged: (value) async {
                  await pl.updateTaskSatus(widget.task!, value!);
                  setState(() {
                    print('${widget.task!.id} task id');
                    widget.task!.status = value;
                  });
                }),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditTask(
                            task: widget.task,
                          )));
            },
            subtitle: Text(intl.DateFormat.yMMMMd()
                .format(widget.task!.startTime!.toDate())),
          ),
        ));
  }
}
