import 'package:flutter/material.dart';
import 'package:plansmanager/provider/user.dart';

class MyProfileScreen extends StatefulWidget {
  MyProfileScreen({Key? key, @required this.user}) : super(key: key);
  final User? user;
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  User? user;
  @override
  void initState() {
    if (widget.user != null) {
      print('userrr');
      user = widget.user!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
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
              child: user != null
                  ? Text(
                      user!.name!.substring(0, 2),
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  : null,
            ),
            Form(
                child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    enabled: false,
                      initialValue: user!.name!,
                      cursorColor: Colors.purple,
                      decoration: InputDecoration(
                          labelText: 'الاسم',
                          labelStyle: TextStyle(color: Colors.purple),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 0.5),
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
                      enabled: false,
                      initialValue: 'dfsdkwksdjskd',
                      obscureText: true,
                      cursorColor: Colors.purple,
                      decoration: InputDecoration(
                          labelText: 'كلمة المرور',
                          labelStyle: TextStyle(color: Colors.purple),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 0.5),
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
                      enabled: false,
                      initialValue: user!.email,
                      cursorColor: Colors.purple,
                      decoration: InputDecoration(
                          labelText: 'البريد الإلكتروني',
                          labelStyle: TextStyle(color: Colors.purple),
                          enabledBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 0.5),
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
                    onPressed: () {},
                    child: Text('حفظ'),
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
