import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/main.dart';

class RegisterScreen extends StatefulWidget {
  static final routeName = 'RegisterScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _teamNameController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isloading = false;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[200]!,
              Colors.blue[300]!,
              Colors.blue[400]!,
              Colors.blue[500]!,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
                Container(
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
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '';
                                  }
                                  return null;
                                },
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.black),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  labelText: 'الاسم',
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
                            // Text('تسجيل حساب جديد',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
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
                                    color: Colors.black,
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
                                    color: Colors.black,
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
                            SizedBox(
                              height: 20,
                            ),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: TextFormField(
                                obscureText: true,

                                // autovalidateMode:
                                //     AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ادخل كلمة المرور';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'الكلمتان غير متطابقتان';
                                  }
                                  return null;
                                },
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                  labelText: 'تأكيد كلمة المرور',
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'ادخل كلمة المرور';
                                  }
                                  return null;
                                },
                                controller: _teamNameController,
                                onTap: () async {
                                  List teams = await FirebaseFirestore.instance
                                      .collection('teams')
                                      .get()
                                      .then((value) => value.docs.first
                                          .data()
                                          .entries
                                          .map((e) => e.value)
                                          .toList());
                                  showMaterialScrollPicker(
                                      title: 'اختر الفريق',
                                      headerTextColor: Colors.white,
                                      onChanged: (selectedTeam) {
                                        _teamNameController.text =
                                            selectedTeam.toString();
                                      },
                                      context: context,
                                      items: teams,
                                      selectedItem: 's');
                                },
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.people,
                                    color: Colors.black,
                                  ),
                                  labelText: 'اسم الفريق',
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

                            _isloading
                                ? CircularProgressIndicator()
                                : SizedBox(
                                    width: 200,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          FocusScope.of(context).unfocus();
                                          _register();
                                        }
                                      },
                                      child: Text('تسجيل'),
                                    ),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: !_isloading
                                        ? () {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    LoginScreen.routeName);
                                          }
                                        : null,
                                    child: Text('تسجيل الدخول'))
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _register() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserCredential? _userCredential;
    try {
      setState(() {
        _isloading = true;
      });
      _userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _userCredential.user!.updateDisplayName(_nameController.text);
      await firestore.collection('users').doc(_userCredential.user!.uid).set({
        'id': _userCredential.user!.uid,
        'name': _nameController.text,
        'email': _emailController.text,
        'teamName': _teamNameController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('تم التسجيل بنجاح'),
        backgroundColor: Colors.green,
      ));
      Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);

      setState(() {
        _isloading = false;
      });
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
