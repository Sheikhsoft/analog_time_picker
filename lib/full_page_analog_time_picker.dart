library analog_time_picker;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'analog_time_picker.dart';
import 'utils.dart';

class FullPageAnalogTimePicker extends StatelessWidget {
  final Map mapData;
  final String route;
  final Widget container;

  FullPageAnalogTimePicker({Key key, this.mapData, this.container, this.route})
      : super(key: key);

  Map<String, DateTime> _dateTime = new Map();
  @override
  Widget build(BuildContext context) {
    print(mapData);
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            container != null ? container : Container(),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 50.0),
              child: AnalogTimePicker(
                onChanged: getDayTime,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.black87,
                child: Icon(Icons.arrow_forward),
                onPressed: () {
                  //print(_dateTime);
                  mapData['date'] =
                      DateFormat.yMMMMd().format(_dateTime['date']).toString();
                  mapData['time'] =
                      DateFormat.jm().format(_dateTime['time']).toString();
                  Navigator.pushNamed(context, '/sixth', arguments: mapData);
                  // print(DateFormat.yMMMMd().format(_dateTime['date']));
                },
              ),
            ),
            MyBackButton(),
          ],
        ),
      ),
    );
  }

  void getDayTime(Map value) {
    _dateTime = value;
  }
}
