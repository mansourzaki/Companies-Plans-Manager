import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/Screens/all_user_tasks_screen.dart';
import 'package:plansmanager/provider/user.dart';

class UserPlansScreen extends StatefulWidget {
  const UserPlansScreen({Key? key, @required this.user}) : super(key: key);
  final User? user;
  @override
  _UserPlansScreenState createState() => _UserPlansScreenState();
}

bool? _isLoading;

class _UserPlansScreenState extends State<UserPlansScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title:
            Text(' خطط ${widget.user!.name}', textDirection: TextDirection.rtl),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('plans')
            .where('userId', isEqualTo: widget.user!.id)
            .snapshots(),
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
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                      itemBuilder: (context, i) {
                        return ListTile(
                          tileColor: Colors.black12,
                          subtitle: Text(''),
                          onTap: () async {
                            var t = await snapshot.data!.docs[i].reference
                                .collection('tasks')
                                .get();
                            setState(() {
                              _isLoading = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllUsersTasks(
                                          doc: snapshot.data!.docs[i],
                                        )));
                          },
                          trailing: Icon(Icons.folder),
                          title: Text(
                            snapshot.data!.docs[i]['name'],
                            textAlign: TextAlign.right,
                          ),
                        );
                      },
                      separatorBuilder: (context, i) => Divider(),
                      itemCount: snapshot.data!.docs.length));
        },
      ),
    );
  }
}
