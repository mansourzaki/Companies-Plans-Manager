import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plansmanager/Screens/forgot_password_screen.dart';
import 'package:plansmanager/Screens/plans_screen.dart';
import 'package:plansmanager/Screens/home_screen.dart';
import 'package:plansmanager/Screens/teamLeaderScreen/allmember.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:provider/provider.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import './provider/user.dart' as usser;
import 'package:firebase_core/firebase_core.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.notification!.body}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => Plan(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(),
        primaryTextTheme: GoogleFonts.almaraiTextTheme(),
        primarySwatch: Colors.blue,
      ),
      //to get the cashed user token and sign in automatically
      home: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
          if (snapshot1.connectionState == ConnectionState.waiting) {}
          if (snapshot1.data == null) {
            return Center();
          }
          usser.User user = usser.User(
            snapshot1.data!['id'],
            snapshot1.data!['name'],
            email: snapshot1.data!['email'],
            isLeader: snapshot1.data!['isLeader'],
            team: snapshot1.data!['teamName'],
          );
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnashot) {
              if (userSnashot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (userSnashot.hasData) {
                print('hi');
                print(userSnashot.data);
                return MyHomePage(user: user);
              }
              print('hi');
              return LoginScreen();
            },
          );
        },
      ),
      routes: {
        MyHomePage.routeName: (cts) => MyHomePage(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
        PlansScreen.routeName: (ctx) => PlansScreen(),
        // AddNewTask.routeName: (ctx) => AddNewTask()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static final routeName = 'MyHomePage';
  MyHomePage({Key? key, this.user}) : super(key: key);
  final usser.User? user;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  @override
  void initState() {
    messaging = FirebaseMessaging.instance;
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .get()
    //     .then((value) => isAdmin = value.get('isLeader'));

    messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: true,
        sound: true,
        announcement: true,
        criticalAlert: true);
    messaging.getToken().then((value) {
      print('token = $value');
    });
    FirebaseMessaging.onMessage.listen((event) {
      print('message recieved');
      print(event.notification!.body);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('message Clicked');
    });
    super.initState();
  }

  final List<Widget> _screens = [
    PlansScreen(),
    HomeScreen(),
  ];

  int _currentIndex = 0;
  final pageController = PageController();
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: Drawer(
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: UserAccountsDrawerHeader(
                  otherAccountsPictures: [
                    CircleAvatar(
                      backgroundColor: Colors.blue[200],
                      child: Text(
                        'M A',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                  otherAccountsPicturesSize: Size.fromRadius(30),
                  decoration: BoxDecoration(color: Colors.amber[300]),
                  accountName:
                      Text(FirebaseAuth.instance.currentUser!.displayName!),
                  accountEmail:
                      Text(FirebaseAuth.instance.currentUser!.email!)),
            ),
            ListTile(
              trailing: Icon(Icons.task),
              title: Text(
                'الخطط',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            ListTile(
              trailing: Icon(Icons.settings),
              title: Text(
                'الإعدادات',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Divider(),
            widget.user!.isLeader!
                ? ListTile(
                    trailing: Icon(Icons.task),
                    title: Text(
                      'خطط الفريق',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllTeamMemmbers(
                                    user: widget.user,
                                  )));
                    },
                  )
                : SizedBox(),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),

        title: Text(_currentIndex == 0 ? 'الخطط' : 'المهام'),
        centerTitle: true,
        backgroundColor: Colors.white,

        leading: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              context.read<Plan>().clearAllTasks();
              context.read<Plan>().clearCurrent();
              Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
            },
            icon: Icon(Icons.exit_to_app)),

        // IconButton(
        //     onPressed: () async {
        //       Task task =
        //           Task(startTime: Timestamp.now(), endTime: DateTime.now());
        //       FirebaseFirestore.instance.collection('tasks').add({
        //         'planId': context.read<Plan>().getCurrentPlan(),
        //         'name': task.name,
        //         'startTime': task.startTime,
        //         'endTime': task.endTime,
        //         'status': task.status,
        //         'workHours': task.workHours,
        //         'teams': task.teams,
        //         'type': task.type,
        //         'ach': task.ach,
        //         'percentage': task.percentage,
        //         'notes': task.notes,
        //         'shared': task.teams!.isEmpty ? false : true
        //       });
        //     },
        //     icon: Icon(Icons.add))
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.projectDiagram), label: 'الخطط'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'المهام'),
        ],
      ),
    );
  }
}
