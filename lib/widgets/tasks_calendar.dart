import 'package:flutter/material.dart';
import 'package:plansmanager/provider/plan.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class TasksCalendar extends StatefulWidget {
  const TasksCalendar({
    Key? key,
  }) : super(key: key);
  void setDayForToday() {
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  _TasksCalendarState createState() => _TasksCalendarState();
}

// Map<DateTime, List<dynamic>>? _events;
// List<dynamic>? _selectedEvents;
DateTime? _focusedDay = DateTime.now();
DateTime? _selectedDay = DateTime.now();
CalendarFormat _calendarFormat = CalendarFormat.week;

class _TasksCalendarState extends State<TasksCalendar> {
  GlobalKey myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010),
      lastDay: DateTime.utc(2050),
      focusedDay: _focusedDay!,
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        // if (!isSameDay(DateTime.now(), selectedDay)) {
        context.read<Plan>().setTasksBasedOnSelectedDay(selectedDay.day);
        print('selected day is $selectedDay');
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        // }
      },
      onHeaderTapped: (date) {
        context.read<Plan>().setTasksBasedOnSelectedMonth(date.month);
        
        // _focusedDay = date;
        //  _selectedDay = date;

        if (date.month != DateTime.now().month) {
          // context.read<Plan>().clearCurrent();
        }
        // print(date.month);
        //  context.read<Plan>().getPlans(month: date.month);
      },
      // onPageChanged: (date) {
      //   context.read<Plan>().getPlans(month: date.month);
      // },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      calendarStyle: CalendarStyle(
        canMarkersOverflow: true,
        todayDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        formatButtonShowsNext: false,
        formatButtonTextStyle: TextStyle(color: Colors.white),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
        todayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
