import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';

class User with ChangeNotifier {
  final String id;
  final String name;
  String? email;
  String? team = 'Undefined';
  User(this.id, this.name, {this.team, this.email});

  Future<void> addUser(User user) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'teamName': user.team,
    });
  }
}
