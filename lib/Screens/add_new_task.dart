import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;

import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:plansmanager/widgets/custom_stepper.dart';
import 'package:provider/provider.dart';

enum Type { dev, supp }
enum Ach { inn, out }
List<String> labels = ['دعم فني', 'تصميم', 'برمجة'];

class AddNewTask extends StatefulWidget {
  const AddNewTask({
    Key? key,
  }) : super(key: key);
  static final routeName = 'AddNewTaskScreen';
  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  //final _workHoursController = TextEditingController();
  final _percentageController = TextEditingController();
  final _notesController = TextEditingController();
  String? _t = 'تطوير';
  String? _a = 'داخل';
  Timestamp? _date;
  bool _isloading = false;
  int _workhours = 0;
  List<String> _teams = [];
  Type? _type = Type.dev;
  Ach? _ach = Ach.inn;
  Task? _myTask = Task(); //missing id
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          _isloading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ],
                )
              : IconButton(
                  onPressed: () async {
                    String? current =
                        Provider.of<Plan>(context, listen: false).current;
                    setState(() {
                      _isloading = true;
                    });
                    _formKey.currentState!.save();
                    try {
                      if (_formKey.currentState!.validate()) {
                        print('$_t fiiirst');

                        // print(Timestamp.fromDate(
                        //          DateTime.parse(_dateController.text)));
                        print(_dateController.text);
                        print('${_teams.length} teeeest ');
                        if (_date != null) {
                          //missing id
                          _myTask = Task(
                            name: _nameController.text,
                            startTime: _date,
                            endTime: DateTime.now(),
                            workHours: _workhours,
                            ach: _a,
                            type: _t,
                            notes: _notesController.text,
                            percentage: int.parse(
                                _percentageController.text == ''
                                    ? '0'
                                    : _percentageController.text),
                            status: false,
                            teams: _teams,
                          );

                          await context
                              .read<Plan>()
                              .addTask(
                                  _myTask!, _myTask!.startTime!.toDate().month)
                              .onError((error, stackTrace) => print('aaa'));

                          setState(() {
                            _isloading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('تم'),
                            backgroundColor: Colors.green,
                          ));
                          Navigator.of(context).pop();
                        }
                      } else {
                        print('cant add $current');
                        setState(() {
                          _isloading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'تأكد من المعلومات المدخلة',
                          ),
                          backgroundColor: Theme.of(context).errorColor,
                        ));
                      }
                    } catch (e) {
                      print('in exc');
                    }
                  },
                  icon: Icon(
                    Icons.add_task_sharp,
                    size: 30,
                  ))
        ],
        title: Text('إضافة مهمة جديدة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      maxLines: 2,
                      controller: _nameController,
                      onSaved: (value) {
                        _myTask!.name = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'اسم المهمة',
                        prefixIcon: Icon(
                          Icons.task,
                          color: Colors.amber,
                        ),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.amber[700] ?? Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      margin: EdgeInsets.only(top: 15),
                      width: 150,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          controller: _dateController,
                          focusNode: AlwaysDisabledFocusNode(),
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.datetime,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(DateTime.now().year),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              _dateController.text =
                                  intl.DateFormat.yMd().format(date);
                            }
                            _date = Timestamp.fromDate(date!);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Colors.amber,
                            ),
                            labelText: 'التاريخ',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                width: 2,
                                color: Colors.amber[700] ?? Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: CustomStepper(
                              onChanged: (value) {
                                _workhours = value;
                              },
                              minValue: 0,
                              maxValue: 6,
                              stepValue: 1,
                              iconSize: 20,
                              value: _workhours)),
                      Expanded(
                        child: Container(
                          alignment: AlignmentDirectional.bottomEnd,
                          margin: EdgeInsets.symmetric(horizontal: 13),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                text: 'ساعات العمل',
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                              WidgetSpan(
                                  child: SizedBox(
                                    width: 5,
                                  ),
                                  alignment: PlaceholderAlignment.middle),
                              WidgetSpan(
                                  child: Icon(
                                    Icons.timelapse,
                                    color: Colors.amber,
                                  ),
                                  alignment: PlaceholderAlignment.middle),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  //radio supp or dev
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'نوع المهمة',
                          style: GoogleFonts.almarai(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        WidgetSpan(
                            child: SizedBox(
                              width: 5,
                            ),
                            alignment: PlaceholderAlignment.middle),
                        WidgetSpan(
                            child: Icon(
                              Icons.support_agent,
                              color: Colors.amber,
                            ),
                            alignment: PlaceholderAlignment.middle),
                      ]),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: RadioListTile<Type>(
                            toggleable: true,
                            title: Text('دعم فني'),
                            value: Type.supp,
                            groupValue: _type,
                            activeColor: Colors.amber[700],
                            onChanged: (value) {
                              setState(() {
                                _type = value;
                                _t = 'دعم';
                              });
                            }),
                      ),
                      Expanded(
                        child: RadioListTile<Type>(
                            title: Text('تطوير'),
                            activeColor: Colors.amber[700],
                            value: Type.dev,
                            groupValue: _type,
                            onChanged: (value) {
                              setState(() {
                                _type = value;
                                _t = 'تطوير';
                              });
                            }),
                      ),
                    ],
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          child: TextFormField(
                            controller: _percentageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'النسبة',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              prefixIcon: Icon(
                                CupertinoIcons.percent,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            ':الإنجاز',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //ach radios
                  Row(children: [
                    Expanded(
                      child: RadioListTile<Ach>(
                          title: Text('داخل الخطة'),
                          activeColor: Colors.amber[700],
                          value: Ach.inn,
                          groupValue: _ach,
                          onChanged: (value) {
                            setState(() {
                              _ach = value;
                              _a = 'داخل';
                            });
                          }),
                    ),
                    Expanded(
                      child: RadioListTile<Ach>(
                          title: Text('خارج الخطة'),
                          activeColor: Colors.amber[700],
                          value: Ach.out,
                          groupValue: _ach,
                          onChanged: (value) {
                            setState(() {
                              _ach = value;
                              _a = 'خارج الخطة';
                            });
                          }),
                    ),
                  ]),
                  Divider(),
                  //teams
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .get(),
                        builder: (context, snapshot) {
                          // QuerySnapshot<Map<String,dynamic>>
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading');
                          }
                          //after checking connectio state to avoid null check operation
                          labels = snapshot.data!.docs
                              .map((e) => e['name'].toString())
                              .toList();
                          return ChipsInput<String>(
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.people,
                                  color: Colors.amber,
                                ),
                                labelText: 'الفرق المساندة',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.amber[700] ?? Colors.black,
                                  ),
                                ),
                              ),
                              chipBuilder: (context, state, data) {
                                return InputChip(
                                  key: ObjectKey(data),
                                  label: Text(data),
                                  onDeleted: () => state.deleteChip(data),
                                );
                              },
                              suggestionBuilder: (context, state, data) {
                                return ListTile(
                                  key: ObjectKey(data),
                                  title: Text(data),
                                  onTap: () => state.selectSuggestion(data),
                                );
                              },
                              findSuggestions: _findSuggestions,
                              onChanged: (input) {
                                _teams = input;
                                print('$input sddd teest');
                                print(_teams);
                              });
                        },
                      )),
                  Divider(),

                  //notes
                  Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'الملاحظات',
                          style: GoogleFonts.almarai(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                        WidgetSpan(
                            child: SizedBox(
                              width: 5,
                            ),
                            alignment: PlaceholderAlignment.middle),
                        WidgetSpan(
                            child: Icon(
                              Icons.notes,
                              color: Colors.amber,
                            ),
                            alignment: PlaceholderAlignment.middle),
                      ]),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),

                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: _notesController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          labelText: 'ملاحظات',
                          alignLabelWithHint: true,
                          labelStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: 2,
                              color: Colors.amber[700] ?? Colors.black,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

Future<List<String>> _findSuggestions(String input) async {
  List<String> list = [];

  if (input.length != 0) {
    list.addAll(labels.where((e) => e.contains(input)));
    return list;
  } else {
    return [];
  }
}
