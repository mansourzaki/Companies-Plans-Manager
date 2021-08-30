import 'package:flutter/material.dart';
import 'package:plansmanager/provider/user.dart' as usser;
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key, @required this.user}) : super(key: key);
  final usser.User? user;
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user;
  @override
  void initState() {
    if (widget.user != null) {
      print('userrr');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تغيير كلمة المرور'),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color(0xffF0F4FD),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.vpn_key,
                color: Colors.white,
                size: 35,
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          controller: _oldPass,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'قم بإدخال كلمة المرور القديمة';
                            } else if (value == 'error') {
                              return 'تأكد من كلمة المرور الحالية';
                            } else {
                              return null;
                            }
                          },
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                              labelText: 'كلمة المرور الحالية',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              labelStyle: TextStyle(color: Colors.purple),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purple, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
                              ))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'قم بإدخال كلمة مرور ';
                            } else if (value.length < 6) {
                              return 'كلمة المرور يجب ان تتكون من 6 أحرف على الأقل';
                            } else {
                              return null;
                            }
                          },
                          controller: _newPass,
                          obscureText: true,
                          cursorColor: Colors.purple,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.purple),
                              labelText: 'كلمة المرور',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purple, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
                              ))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                          controller: _confPass,
                          obscureText: true,
                          cursorColor: Colors.purple,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value != _newPass.text) {
                              return 'الكلمتان غير متطابقتان';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'تأكيد كلمة المرور',
                              labelStyle: TextStyle(color: Colors.purple),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.purple, width: 0.5),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.purple, width: 2),
                              ))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () async {
                          final ref = FirebaseAuth.instance.currentUser!;

                          if (_formKey.currentState!.validate()) {
                            try {
                              UserCredential userCredential = await FirebaseAuth
                                  .instance
                                  .signInWithEmailAndPassword(
                                      email: widget.user!.email!,
                                      password: _oldPass.text);

                              ref.updatePassword(_newPass.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('تم تغيير كلمة المرور بنجاح'),
                                backgroundColor: Colors.green,
                              ));
                              Navigator.of(context).pop();
                            } catch (error) {
                              _oldPass.text = 'error';
                              _formKey.currentState!.validate();
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //         content:
                              //             Text('تأكد من كلمة المرور الحالية'),
                              //         backgroundColor: Colors.red));
                            }
                          }
                        },
                        child: Text('تغيير كلمة المرور'),
                        style: ElevatedButton.styleFrom(primary: Colors.purple),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
