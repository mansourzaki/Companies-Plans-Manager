import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/provider/task.dart';

class User with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  List<Task>? tasksList;
  String? team = 'Undefined';
  User(this.id, this.name, this.email, {this.team});

  Future<void> addUser(User user) async {
    await FirebaseFirestore.instance.collection('Users').add({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'teamName': user.team,
    });
  }
}
