import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class User with ChangeNotifier {
  String? id;
  String? name;
  bool? isLeader = false;
  bool? isAdmin = false;
  String? email;
  String? team = 'Undefined';

  User(this.id, this.name,
      {this.team, this.email, this.isLeader, this.isAdmin});

  // User? currentUser;
  Future<void> addUser(User user) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'teamName': user.team,
    });
  }

  // Future<void> getCurrentUser(String uid) async {
  //   try {
  //     final ref =
  //         await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //     String id = ref.data()!['id'];
  //     String name = ref.data()!['name'];
  //     String email = ref.data()!['email'];
  //     String teamName = ref.data()!['teamName'];
  //     bool isLeader = ref.data()!['isLeader'];
  //     User user =
  //         User(id, name, email: email, isLeader: isLeader, team: teamName);
  //     this.currentUser = user;
  //     notifyListeners();
  //   } catch (error) {
  //     print('catch $error ');
  //   }
  // }
}
