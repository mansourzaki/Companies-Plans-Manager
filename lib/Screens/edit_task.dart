import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chips_input/flutter_chips_input.dart';
import 'package:intl/intl.dart' as intl;
import 'package:plansmanager/exceptions/custom_exception.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:plansmanager/provider/task.dart';
import 'package:provider/provider.dart';

enum Type { dev, supp }
enum Ach { inn, out }
final List<String> labels = ['دعم فني', 'تصميم', 'برمجة'];

class EditTask extends StatefulWidget {
  Task? task;
  EditTask({Key? key, this.task}) : super(key: key);

  static final routeName = 'AddNewTaskScreen';
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  void initState() {
    _nameController.text = widget.task!.name!;
    _dateController.text =
        intl.DateFormat.yMd().format(widget.task!.startTime!.toDate());
    _date = widget.task!.startTime!;
    _notesController.text = widget.task!.notes!;
    _workHoursController.text = widget.task!.workHours.toString();
    _percentageController.text = widget.task!.percentage.toString();
    _type = widget.task!.type == 'تطوير' ? Type.dev : Type.supp;
    _ach = widget.task!.ach == 'داخل' ? Ach.inn : Ach.out;
    _teams = widget.task!.teams!.cast<String>();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _workHoursController = TextEditingController();
  final _percentageController = TextEditingController();
  final _notesController = TextEditingController();
  String? _t = 'تطوير';
  String? _a = 'داخل';
  Timestamp? _date;
  DateTime? date;
  bool _isloading = false;
  List<String> _teams = [];
  Type? _type;
  Ach? _ach = Ach.inn;
  Task? _myTask = Task(); //missing id
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                String? current =
                    Provider.of<Plan>(context, listen: false).current;
                // setState(() {
                //   _isloading = true;
                // });
                _formKey.currentState!.save();
                try {
                  if (_formKey.currentState!.validate()) {
                    if (_date != null) {
                      print('pressed');
                      //missing id
                      _myTask = Task(
                        id: widget.task!.id,
                        name: _nameController.text,
                        startTime: _date,
                        endTime: DateTime.now(),
                        workHours: int.parse(_workHoursController.text == ''
                            ? '0'
                            : _workHoursController.text),
                        ach: _a,
                        type: _t,
                        notes: _notesController.text,
                        percentage: int.parse(_percentageController.text == ''
                            ? '0'
                            : _percentageController.text),
                        status: widget.task!.status,
                        teams: _teams,
                      );

                      // await context.read<Plan>().addTask(
                      //     _myTask!, _myTask!.startTime!.toDate().month);
                      await context.read<Plan>().updateTask(
                            _myTask!,
                          );
                      // setState(() {
                      //   _isloading = false;
                      // });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('تم'),
                        backgroundColor: Colors.green,
                      ));
                      //  Navigator.of(context).pop();
                    }
                  } else {
                    print('cant add $current');
                    // setState(() {
                    //   _isloading = false;
                    // });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('لا توجد خطة حالية'),
                      backgroundColor: Theme.of(context).errorColor,
                    ));
                  }
                } catch (e) {
                  print('in exc');
                }
              },
              icon: Icon(Icons.save))
        ],
        title: Text('تعديل'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
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
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(
                              color: Colors.red,
                              width: 2.0,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            width: 2,
                            color: Colors.amber[700] ?? Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _workHoursController,
                              decoration: InputDecoration(
                                labelText: 'ساعات العمل',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
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
                      Expanded(
                        child: Container(
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
                              // onSaved: (value) {
                              //   if (date != null) {
                              //     _dateController.text =
                              //         intl.DateFormat.yMd().format(date!);
                              //   }
                              //   _date = Timestamp.fromDate(date!);
                              // },
                              onTap: () async {
                                date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year),
                                  lastDate: DateTime(2030),
                                );
                              },
                              decoration: InputDecoration(
                                labelText: 'التاريخ',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
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
                    ],
                  ),
                  Directionality(
                      textDirection: TextDirection.rtl,
                      child: ChipsInput<String>(
                          initialValue: widget.task!.teams!.cast<String>(),
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: 'الفرق المساندة',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
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
                          })),
                  //radio supp or dev
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          ':الإنجاز',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                      ],
                    ),
                  ),
                  //ach radios
                  Row(
                    children: [
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            padding: EdgeInsets.all(30),
                            child: TextFormField(
                              controller: _percentageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  CupertinoIcons.percent,
                                  color: Colors.black,
                                ),
                                labelText: 'النسبة',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 2.0,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
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
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile<Ach>(
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
                              RadioListTile<Ach>(
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  //notes
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          ':الملاحظات',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                      ],
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
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
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
    list.add(input);
    return list;
  } else {
    return [];
  }
}
