import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plansmanager/Screens/forgot_password_screen.dart';
import 'package:plansmanager/Screens/home_screen.dart';
import 'Screens/login_screen.dart';
import 'Screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.almaraiTextTheme(),
        primarySwatch: Colors.blue,
      ),
      //to get the cashed user token and sign in automatically
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, userSnashot) {
          if (userSnashot.hasData) {
            print('hi');
            return HomeScreen();
          }
          print('hi');
          return LoginScreen();
        },
      ),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: Colors.green,
              child: RichText(
                text: TextSpan(text: 'TEST: ', children: [
                  TextSpan(
                    text: 'HELLO',
                    style: TextStyle(
                        background: Paint()
                          ..color = Colors.red
                          ..strokeWidth = 10
                          ..style = PaintingStyle.fill,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
