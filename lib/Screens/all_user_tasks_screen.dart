import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/provider/task.dart';
import 'package:plansmanager/widgets/task_card.dart';

class AllUsersTasks extends StatefulWidget {
  const AllUsersTasks({Key? key, this.doc}) : super(key: key);
  final QueryDocumentSnapshot? doc;

  @override
  _AllUsersTasksState createState() => _AllUsersTasksState();
}

class _AllUsersTasksState extends State<AllUsersTasks> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(' مهام شهر ${widget.doc!['month']}',
            textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: widget.doc!.reference.collection('tasks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.docs.isEmpty
              ? Center(child: Text('No Plans For This User!'))
              : Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.separated(
                      itemBuilder: (context, i) {
                        Timestamp t = snapshot.data!.docs[i]['endTime'];
                        DateTime d = t.toDate();
                        String date = intl.DateFormat('y/M/dd').format(d);
                        // Task task = Task(
                        //   sharedBy: snapshot.data!.docs[i]['sharedBy'],
                        //   id: snapshot.data!.docs[i].id,
                        //   name: snapshot.data!.docs[i]['name'],
                        //   startTime: snapshot.data!.docs[i]['startTime'],
                        //   endTime: date,
                        //   status: snapshot.data!.docs[i]['status'],
                        //   workHours: snapshot.data!.docs[i]['workHours'],
                        //   teams: snapshot.data!.docs[i]['teams'],
                        //   type: snapshot.data!.docs[i]['type'],
                        //   ach: snapshot.data!.docs[i]['ach'],
                        //   shared: snapshot.data!.docs[i]['shared'],
                        //   percentage: snapshot.data!.docs[i]['percentage'],
                        //   notes: snapshot.data!.docs[i]['notes'],
                        // );
                        return ListTile(
                          trailing: Icon(Icons.task),
                          title: Text(
                            snapshot.data!.docs[i]['name'],
                            textAlign: TextAlign.right,
                          ),
                          subtitle: Text(
                            date,
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                      separatorBuilder: (context, i) {
                        return Divider();
                      },
                      itemCount: snapshot.data!.docs.length),
                );
        },
      ),
    );
  }
}
