import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plansmanager/Screens/home_screen.dart';
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

  DateTime get day {
    if (_selectedDay == null) {
      return DateTime.now();
    } else {
      return _selectedDay!;
    }
  }

  DateTime get month {
    if (_selectedMonth == null) {
      return DateTime.now();
    } else {
      return _selectedMonth!;
    }
  }

  @override
  _TasksCalendarState createState() => _TasksCalendarState();
}

// Map<DateTime, List<dynamic>>? _events;
// List<dynamic>? _selectedEvents;
DateTime? _focusedDay = DateTime.now();
DateTime? _selectedDay = DateTime.now();
DateTime? _selectedMonth = DateTime.now();
CalendarFormat _calendarFormat = CalendarFormat.week;

class _TasksCalendarState extends State<TasksCalendar> {
  GlobalKey myKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // headerVisible: false,
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
          HomeScreen.allmonth = false;
        });

        // }
      },
      onPageChanged: (date) {
        _selectedMonth = date;
        //  context.read<Plan>().getCustomPlan(date.month);
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
        
        defaultTextStyle: GoogleFonts.poppins(),
        outsideTextStyle: GoogleFonts.poppins(),
        weekendTextStyle: GoogleFonts.poppins(),
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
      pageAnimationEnabled: true,
      headerStyle: HeaderStyle(
        titleTextStyle: GoogleFonts.poppins(
          textStyle: TextStyle(fontSize: 17),
        ),
        leftChevronVisible: true,
        rightChevronVisible: true,
        formatButtonVisible: false,
        titleCentered: true,

        // formatButtonDecoration: BoxDecoration(
        //   color: Colors.red[700],
        //   borderRadius: BorderRadius.circular(20),
        // ),
        //formatButtonShowsNext: false,
        // formatButtonTextStyle: TextStyle(color: Colors.white),
      ),
      calendarBuilders: CalendarBuilders(
       
        selectedBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
        todayBuilder: (context, date, events) => Container(
            margin: const EdgeInsets.all(4.0),
            alignment: Alignment.center,
            decoration:
                BoxDecoration(color: Colors.purple, shape: BoxShape.circle),
            child: Text(
              date.day.toString(),
              style: TextStyle(color: Colors.white),
            )),
      ),
    );
  }
}
