import 'package:flutter/material.dart';

class CustomStepper extends StatefulWidget {
  CustomStepper({
    @required this.minValue,
    @required this.maxValue,
    @required this.stepValue,
    @required this.iconSize,
    this.value,
    @required this.onChanged,
  });
  final int? minValue;
  final int? maxValue;
  final int? stepValue;
  final ValueChanged<int>? onChanged;
  int? value;
  final double? iconSize;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          splashRadius: 10,
          splashColor: Colors.red,
          onPressed: widget.onChanged == null
              ? null
              : () {
                  setState(() {
                    widget.value = widget.value == widget.minValue
                        ? widget.minValue!
                        : widget.value = widget.value! - widget.stepValue!;
                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.value!);
                    }
                  });
                },
          icon: Icon(Icons.remove),
          iconSize: widget.iconSize!,
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            '${widget.value}',
            style: TextStyle(fontSize: 15),
          ),
        ),
        IconButton(
          splashRadius: 10,
          splashColor: Colors.green,
          onPressed: widget.onChanged == null
              ? null
              : () {
                  setState(() {
                    widget.value = widget.value == widget.maxValue
                        ? widget.maxValue!
                        : widget.value = widget.value! + widget.stepValue!;
                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.value!);
                    }
                  });
                },
          icon: Icon(Icons.add),
          iconSize: widget.iconSize! * 0.8,
        ),
      ],
    );
  }
}
