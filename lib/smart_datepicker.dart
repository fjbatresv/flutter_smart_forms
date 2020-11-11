import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SmartDatepicker extends StatefulWidget {
  @override
  _SmartDatepickerState createState() => _SmartDatepickerState();
}

class _SmartDatepickerState extends State<SmartDatepicker> {
  DateTime dateTime;

  @override
  void initState() {
    dateTime = DateTime.now().subtract(Duration(days: 6574)); // 18 Years aprox
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
