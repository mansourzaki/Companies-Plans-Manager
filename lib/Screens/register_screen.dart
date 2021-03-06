import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:plansmanager/Screens/admin_screen.dart';
import 'package:plansmanager/Screens/login_screen.dart';
import 'package:plansmanager/main.dart';
import '../provider/user.dart' as user;

class RegisterScreen extends StatefulWidget {
  static final routeName = 'RegisterScreen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _idNumController = TextEditingController();
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
      backgroundColor: Color(0xffF0F4FD),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/iccon2.png',
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 15,
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
                                  color: Colors.purple,
                                ),
                                labelText: '??????????',
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
                                if (value == null ||
                                    value.isEmpty ||
                                    double.tryParse(value) == null ||
                                    value.length > 9) {
                                  return '';
                                }
                                return null;
                              },
                              controller: _idNumController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(
                                  Icons.badge,
                                  color: Colors.purple,
                                ),
                                labelText: '?????? ????????????',
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
                          // Text('?????????? ???????? ????????',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '???????? ???????????? ????????????????';
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
                                labelText: '???????????? ????????????????????',
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
                                  return '???????? ???????? ????????????';
                                }
                                return null;
                              },
                              controller: _passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.purple,
                                ),
                                labelText: '???????? ????????????',
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
                                  return '???????? ???????? ????????????';
                                }
                                if (value != _passwordController.text) {
                                  return '???????????????? ?????? ??????????????????';
                                }
                                return null;
                              },
                              controller: _confirmPasswordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.purple,
                                ),
                                labelText: '?????????? ???????? ????????????',
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
                                  return '???????? ???????? ????????????';
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
                                    title: '???????? ????????????',
                                    headerTextColor: Colors.white,
                                    onChanged: (selectedTeam) {
                                      _teamNameController.text =
                                          selectedTeam.toString();
                                    },
                                    context: context,
                                    headerColor: Colors.purple,
                                    items: teams,
                                    showDivider: false,
                                    selectedItem: 's');
                              },
                              focusNode: AlwaysDisabledFocusNode(),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.people,
                                  color: Colors.purple,
                                ),
                                labelText: '?????? ????????????',
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
                                        primary: Colors.purple,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        _register();
                                      }
                                    },
                                    child: Text('??????????'),
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
                                  child: Text(
                                    '?????????? ????????????',
                                    style: TextStyle(color: Colors.grey),
                                  ))
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

      var ref = await firestore
          .collection('users')
          .where('idNum', isEqualTo: int.parse(_idNumController.text))
          .get();
      if (ref.docs.length >= 1) {
        print('in not empty');
        throw FirebaseAuthException(code: 'wrong id');
      }

      _userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _userCredential.user!.updateDisplayName(_nameController.text);
      await firestore.collection('users').doc(_userCredential.user!.uid).set({
        'id': _userCredential.user!.uid,
        'idNum': int.parse(_idNumController.text),
        'name': _nameController.text,
        'email': _emailController.text,
        'teamName': _teamNameController.text,
        'isLeader': false,
        'isAdmin': false
      });
      user.User newUser = user.User(
        _userCredential.user!.uid,
        _nameController.text,
        team: _teamNameController.text,
        email: _emailController.text,
        isLeader: false,
        isAdmin: false,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('???? ?????????????? ??????????'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => newUser.isAdmin!
                ? AdminScreen()
                : MyHomePage(
                    user: newUser,
                  ),
          ));

      setState(() {
        _isloading = false;
      });
      print(_userCredential);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isloading = false;
      });
      var message = 'An error occured please check your credentials';
      if (e.code == 'wrong id') {
        message = '!?????? ???????????? ???????? ???? ??????';
        _idNumController.clear();
      }
      if (e.message != null) {
        message = e.message!;
      }
      //_showErrorDialog(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            textAlign: TextAlign.right,
          ),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );

      print('Failed with error code: ${e.code}');
      print(e.message);
    } catch (err) {
      setState(() {
        _isloading = false;
      });

      print('gege sign up catch');
      print(err);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
