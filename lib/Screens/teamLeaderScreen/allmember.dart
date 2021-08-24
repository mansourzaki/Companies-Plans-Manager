import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/user.dart';
import 'package:plansmanager/widgets/signOutDialog.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';
import '../user_plans_screen.dart';

class AllTeamMemmbers extends StatefulWidget {
  AllTeamMemmbers({this.user});
  final User? user;
  @override
  _AllTeamMemmbersState createState() => _AllTeamMemmbersState();
}

class _AllTeamMemmbersState extends State<AllTeamMemmbers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(context: context, builder: (_) => SignOutDialog());
              },
              icon: Icon(Icons.exit_to_app)),
        ],
        backgroundColor: Colors.white,
        title: Text('أعضاء الفريق', textDirection: TextDirection.rtl),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('teamName', isEqualTo: widget.user!.team)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('an error occured');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Getting users....'),
            );
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
      ),
    );
  }
}
