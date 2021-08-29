import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static final routeName = 'ForgotPassword';
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F4FD),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/iccon.png',
            width: 150,
            height: 150,
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
              padding: EdgeInsets.all(10),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(LoginScreen.routeName);
                            },
                            child: Text('تسجيل الدخول',
                                style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
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
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        _resetPassword();
                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          _isloading = false;
                        });
                      }
                    },
                    child: Text('أرسل'),
                  ),
                )
        ],
      ),
    );
  }

  Future _resetPassword() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      setState(() {
        _isloading = true;
      });
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      Navigator.of(context).pop();
      // Navigator.of(context).pushRepla print(_userCredential);
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
