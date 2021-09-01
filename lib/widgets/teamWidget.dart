
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TeamWidget extends StatefulWidget {
  const TeamWidget({Key? key}) : super(key: key);

  @override
  _TeamWidgetState createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Container(
        alignment: Alignment.center,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: [
            UserIcon(),
            UserIcon(),
            UserIcon(),
            UserIcon(),
            AddNewMemmberIcon(),
          ],
        ),
      ),
    );
  }
}

class UserIcon extends StatelessWidget {
  const UserIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.purple[100],
            radius: 25,
            child: Icon(
              Icons.person,
              color: Colors.purple,
            ),
          ),
          Text('منصور الحداد')
        ],
      ),
    );
  }
}

class AddNewMemmberIcon extends StatelessWidget {
  const AddNewMemmberIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.purple),
                  shape: BoxShape.circle),
              child: CircleAvatar(
                child: Icon(
                  Icons.add,
                  color: Colors.purple,
                ),
                backgroundColor: Colors.white,
                radius: 24,
              ),
            ),
          ),
          Text('')
        ],
      ),
    );
  }
}
