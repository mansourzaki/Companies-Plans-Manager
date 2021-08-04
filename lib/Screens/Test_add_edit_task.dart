import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/widgets/custom_stepper.dart';
import 'package:provider/provider.dart';

enum Type { dev, supp }
enum Ach { inn, out }
List<String> labels = ['دعم فني', 'تصميم', 'برمجة'];

class TestAddEditScreen extends StatefulWidget {
  TestAddEditScreen({this.task});
  final Task? task;
  @override
  _TestAddEditScreenState createState() => _TestAddEditScreenState();
}

class _TestAddEditScreenState extends State<TestAddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _percentageController = TextEditingController();
  final _notesController = TextEditingController();
  int? _workhours = 0;
  DateTime? _date;
  var _isLoading = false;
  Ach? _ach;
  Type? _type;
  List<String> _teams = [];
  String? _t = 'تطوير';
  String? _a = 'داخل';
  @override
  void initState() {
    Task? task = widget.task;

    if (task != null) {
      _nameController.text = task.name.toString();
      _dateController.text =
          intl.DateFormat('yyyy-MM-dd').format(task.startTime!.toDate());
      _date = task.startTime!.toDate();
      _percentageController.text = task.percentage.toString();
      _notesController.text = task.notes!;
      _workhours = task.workHours!;
      _ach = task.ach == 'داخل' ? Ach.inn : Ach.out;
      _type = task.type == 'تطوير' ? Type.dev : Type.supp;
      _teams = widget.task!.teams!.cast<String>();
    } else {
      print('task is null so switch to addMode');
    }
    super.initState();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    // _dateController.dispose();
    // _percentageController.dispose();
    // _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text('إضافة مهمة'),
          centerTitle: true,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'أدخل اسم';
                        } else {
                          return null;
                        }
                      },
                      controller: _nameController,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black38,
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            )),
                        labelText: 'اسم المهمة',
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Icon(Icons.task, color: Colors.red),
                      ),
                    ),
                  ),
                  Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 200,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          onTap: () async {
                            DateTime? date;
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2021),
                              lastDate:
                                  DateTime(2021, DateTime.now().month + 1),
                            ).then((value) async {
                              TimeOfDay? time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (value != null && time != null) {
                                date = DateTime(value.year, value.month,
                                    value.day, time.hour, time.minute);
                                print(date!.hour);
                                _dateController.text = intl.DateFormat('y/M/d')
                                    .add_jm()
                                    .format(date!);
                                _date = date;
                              }
                            });
                          },
                          focusNode: AlwaysDisabledFocusNode(),
                          controller: _dateController,
                          textDirection: TextDirection.rtl,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'أدخل تاريخ';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black38,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                )),
                            labelText: 'التاريخ',
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Colors.red,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomStepper(
                            value: _workhours,
                            minValue: 0,
                            maxValue: 6,
                            stepValue: 1,
                            iconSize: 20,
                            onChanged: (value) {
                              _workhours = value;
                            }),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: RichText(
                          textDirection: TextDirection.rtl,
                          text: TextSpan(children: [
                            WidgetSpan(
                                child: SizedBox(
                              width: 5,
                            )),
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.timelapse,
                                  color: Colors.red,
                                )),
                            TextSpan(
                                text: 'ساعات العمل',
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)))
                          ]),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ':نوع المهمة',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<Type>(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              activeColor: Colors.red,
                              toggleable: true,
                              title: Text('دعم فني'),
                              secondary: Icon(Icons.support_agent_sharp),
                              value: Type.supp,
                              groupValue: _type,
                              onChanged: (value) {
                                setState(() {
                                  _type = value;
                                  _t = 'دعم';
                                });
                              }),
                        ),
                        Expanded(
                          child: RadioListTile<Type>(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              title: Text('تطوير'),
                              activeColor: Colors.red,
                              toggleable: true,
                              secondary: Icon(
                                Icons.developer_mode,
                                size: 20,
                              ),
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
                  ),
                  Divider(),
                  ListTile(
                    leading: Container(
                        width: 100,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _percentageController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                CupertinoIcons.percent,
                                size: 20,
                                color: Colors.black,
                              ),
                              hintText: '0',
                              border: InputBorder.none),
                        )),
                    trailing: Text(
                      ':الإنجاز',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<Ach>(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 5),
                              activeColor: Colors.red,
                              toggleable: true,
                              title: Text('داخل الخطة'),
                              secondary: Icon(Icons.arrow_downward_outlined),
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
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              title: Text('خارج الخطة'),
                              activeColor: Colors.red,
                              toggleable: true,
                              secondary: Icon(
                                Icons.arrow_upward,
                                size: 20,
                              ),
                              value: Ach.out,
                              groupValue: _ach,
                              onChanged: (value) {
                                setState(() {
                                  _ach = value;
                                  _a = 'خارج';
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .get(),
                        builder: (context, snapshot) {
                          // to avoid null check operation
                          if (snapshot.hasData) {
                            labels = snapshot.data!.docs
                                .map((e) =>
                                    '${e['name'].toString()} - ${e['teamName'].toString()}')
                                .toList();
                          }
                          return ChipsInput<String>(
                              initialValue: _teams,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.people,
                                  color: Colors.red,
                                ),
                                labelText: 'الفرق المساندة',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
                                      width: 2.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                    )),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextFormField(
                        controller: _notesController,
                        textDirection: TextDirection.rtl,
                        maxLines: 7,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black38,
                                width: 2.0,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              )),
                          labelText: 'الملاحظات',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: Icon(Icons.task, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          height: 50,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
              ),
              onPressed: () async {
                Plan plan = context.read<Plan>();
                _formKey.currentState!.save();
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _isLoading = !_isLoading;
                  });

                  Task task = Task(
                    id: widget.task == null ? null : widget.task!.id,
                    name: _nameController.text,
                    startTime: Timestamp.fromDate(_date!),
                    endTime: DateTime.now(),
                    workHours: _workhours,
                    ach: _a,
                    type: _t,
                    notes: _notesController.text,
                    percentage: int.parse(_percentageController.text == ''
                        ? '0'
                        : _percentageController.text),
                    status: false,
                    teams: _teams,
                  );
                  if (_teams.isNotEmpty) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .where('teamName', isEqualTo: _teams[0])
                        .get()
                        .then((value) => value.docs.first.id);
                  }

                  try {
                    widget.task == null
                        ? await plan
                            .addTask(task, DateTime.now().month)
                            .then((value) {
                            setState(() {
                              _isLoading = !_isLoading;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('تم'),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.of(context).pop();
                          }).onError((error, stackTrace) {
                            print('error catched');
                          })
                        : await plan
                            .updateTask(
                            task,
                          )
                            .then((value) {
                            setState(() {
                              _isLoading = !_isLoading;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('تم'),
                                backgroundColor: Colors.green,
                              ));
                              Navigator.of(context).pop();
                            });
                          }).onError((error, stackTrace) {
                            print('error catched');
                          });
                  } catch (error) {
                    print(error);
                  }

                  // print(_date);
                  // print('${_ach.toString()} ach');
                  // print(_dateController.text);
                  // print('${_nameController.text} name');
                  // print('${_notesController.text} notes');
                  // print('$_workhours workhours');
                  // print('${_percentageController.text}');
                  // print('$_teams teeams');
                }
              },
              child: _isLoading
                  ? LoadingIndicator(
                      indicatorType: Indicator.ballBeat,
                      colors: [Colors.black38, Colors.red],
                    )
                  : widget.task == null
                      ? Text(
                          'إضافة',
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          'تعديل',
                          style: TextStyle(fontSize: 20),
                        )),
        ));
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
