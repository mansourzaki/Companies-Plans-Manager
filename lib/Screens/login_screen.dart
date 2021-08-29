import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plansmanager/Screens/admin_screen.dart';
import 'package:plansmanager/Screens/forgot_password_screen.dart';
import 'package:plansmanager/Screens/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plansmanager/main.dart';
import '../provider/user.dart' as user;

class LoginScreen extends StatefulWidget {
  static final routeName = 'LoginScreen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isloading = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'حدث خطأ!',
          textAlign: TextAlign.end,
        ),
        content: Text(message, textAlign: TextAlign.end),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  bool checkIfLoggedIn() {
    if (FirebaseAuth.instance.currentUser != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xffF0F4FD),
      // body: Container(
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [
      //         Colors.blue[200]!,
      //         Colors.blue[300]!,
      //         Colors.blue[400]!,
      //         Colors.blue[500]!,
      //       ],
      //     ),
      //   ),
      //   //child: Center(
      //   //   child: Stack(
      //   //  alignment: Alignment.center,
      //   //  children: [
      //   child:
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: _height*0.1,
            ),
            Image.asset(
              'assets/images/iccon.png',
              width: 150,
              height: 150,
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 6,
                          blurRadius: 8,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  margin: EdgeInsets.all(10),
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 20),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ادخل البريد الكتروني';
                              }
                              return null;
                            },
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.purple,
                              ),
                              labelText: 'البريد الإلكتروني',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'ادخل كلمة المرور';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.purple,
                              ),
                              labelText: 'كلمة المرور',
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacementNamed(
                                    RegisterScreen.routeName);
                              },
                              child: Text(
                                'تسجيل حساب جديد',
                                style: GoogleFonts.almarai(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ForgotPasswordScreen.routeName);
                              },
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: GoogleFonts.almarai(
                                  textStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
            _isloading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          _login();
                          print(_passwordController.text);
                        }
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: GoogleFonts.almarai(textStyle: TextStyle()),
                      ),
                    ),
                  )
          ],
        ),
      ),

      // ],
      //    ),
      // ),
    );
  }

  Future _login() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    UserCredential? _userCredential;
    try {
      setState(() {
        _isloading = true;
      });
      _userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      DocumentSnapshot userRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredential.user!.uid)
          .get();
      user.User newUser = user.User(
        userRef.id,
        userRef['name'],
        team: userRef['teamName'],
        email: userRef['email'],
        isLeader: userRef['isLeader'],
        isAdmin: userRef['isAdmin'],
      );

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => newUser.isAdmin!
                ? AdminScreen()
                : MyHomePage(
                    user: newUser,
                  ),
          ));
      print(_userCredential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isloading = false;
      });
      var message = 'An error occured please check your credentials';
      if (e.message != null) {
        message = e.message!;
      }
      //_showErrorDialog(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      print('Failed with error code: ${e.code}');
      print(e.message);
    } catch (err) {
      setState(() {
        _isloading = false;
      });
      print(err);
    }
  }
}
