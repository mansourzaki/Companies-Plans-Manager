import 'package:flutter/material.dart';

class PlanCard extends StatelessWidget {
  final name;
  final startDate;
  final endDate;
  final teamName;
  PlanCard({
    @required this.name,
    @required this.startDate,
    @required this.endDate,
    @required this.teamName,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue[200],
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.2),
        //     offset: Offset(2, 3),
        //     blurRadius: 5,
        //   ),
        // ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(name),
        ],
      ),
      
    );
  }
}
