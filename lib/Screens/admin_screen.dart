import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/Screens/user_plans_screen.dart';
import 'package:plansmanager/provider/user.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('جميع المستخدمين'),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            List<User> users = snapshot.data!.docs
                .map((e) => User(
                      e['id'],
                      e['name'],
                      isLeader: e['isLeader'],
                      email: e['email'],
                      team: e['teamName'],
                    ))
                .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                  separatorBuilder: (context, i) => Divider(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) => ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserPlansScreen(
                                        user: users[i],
                                      )));
                        },
                        tileColor: Colors.amber,
                        trailing: Icon(Icons.person),
                        title: Text(
                          '${users[i].name}',
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(
                          '${users[i].team}',
                          textAlign: TextAlign.right,
                        ),
                      )),
            );
          },
        ));
  }
}
