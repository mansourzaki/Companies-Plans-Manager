import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plansmanager/Screens/Test_add_edit_task.dart';
import 'package:plansmanager/Screens/add_new_task.dart';
import 'package:plansmanager/Screens/forgot_password_screen.dart';
import 'package:plansmanager/Screens/plans_screen.dart';
import 'package:plansmanager/Screens/home_screen.dart';
import 'package:plansmanager/provider/plan.dart';

import 'package:provider/provider.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnashot) {
          if (userSnashot.hasData) {
            print('hi');

            return MyHomePage();
          }
          print('hi');
          return LoginScreen();
        },
      ),
      routes: {
        MyHomePage.routeName: (cts) => MyHomePage(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
        PlansScreen.routeName: (ctx) => PlansScreen(),
        AddNewTask.routeName: (ctx) => AddNewTask()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  static final routeName = 'MyHomePage';
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'الخطط' : 'المهام'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                context.read<Plan>().clearAllTasks();
                context.read<Plan>().clearCurrent();
                Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
              },
              icon: Icon(Icons.exit_to_app))
        ],
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
