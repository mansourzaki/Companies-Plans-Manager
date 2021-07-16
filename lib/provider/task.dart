import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Task with ChangeNotifier{
  String? name;
  DateTime? startTime;
  DateTime? endTime;

  Task({
    this.name,
    this.startTime,
    this.endTime
  });

  Future getTasks() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference ref = firestore.collection('Plans');
    DocumentSnapshot snapshot = await ref.doc('riPpQ6rXySIpV5Xj4b7Z').get();
    
    
    
  }
}
