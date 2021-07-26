import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class TaskCard extends StatelessWidget {
  TaskCard(this.name, this.date);
  String name;
  Timestamp date;
  @override
  Widget build(BuildContext context) {
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
            title: Text(name),
            leading: Icon(Icons.task),
            onTap: () {},
            subtitle: Text(intl.DateFormat.yMMMMd()
                .format(date.toDate())),
          ),
        ));
  }
}
