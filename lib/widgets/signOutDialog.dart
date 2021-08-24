import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:provider/provider.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('تسجيل الخروج'),
      content: Text('هل أنت متأكد'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('لا')),
        TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.read<Plan>().clearAllTasks();
              context.read<Plan>().clearCurrent();
              Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
            },
            child: Text('نعم')),
      ],
    );
  }
}
