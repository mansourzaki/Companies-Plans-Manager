import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:plansmanager/provider/task.dart';
import '../provider/user.dart' as user;

class DatabaseService {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final CollectionReference plansCollection =
      FirebaseFirestore.instance.collection('plans');

  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> map = doc['users'];
      return Task(
        id: doc.id,
        name: doc['name'],
        startTime: doc['startTime'],
        endTime: DateTime.now(),
        workHours: doc['workHours'],
        ach: doc['ach'],
        type: doc['type'],
        notes: doc['notes'],
        percentage: doc['percentage'],
        status: doc['false'],
        teams: doc['teams'],
        shared: doc['shared'],
        users: map.entries.map((e) => user.User(e.key, e.value)).toList(),
      );
    }).toList();
  }

  Stream<List<Task>> get brews {
    return plansCollection.snapshots().map(_taskListFromSnapshot);
  }
}
