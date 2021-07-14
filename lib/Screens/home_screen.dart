import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/Screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  static final routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  List _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  Widget build(BuildContext context) {
    //final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
      ),
      body: Container(
        //margin: EdgeInsets.only(left: 10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _months.length,
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      width: 100,
                      child: Text(_months[i]),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blue[200]),
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    color: Colors.red,
                    height: 40,
                    child: Column(),
                  ),
                  Container(
                    color: Colors.red,
                    height: 40,
                    child: Column(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
