library analog_time_picker;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'timepicker/clock.dart';
import 'timepicker/clock_text.dart';

class AnalogTimePicker extends StatefulWidget {
  final ValueChanged<Map> onChanged;

  const AnalogTimePicker({Key key, this.onChanged}) : super(key: key);
  @override
  _AnalogTimePickerState createState() => _AnalogTimePickerState();
}

class _AnalogTimePickerState extends State<AnalogTimePicker> {
  Map<String, DateTime> _dateTime = new Map();

  DateTime colckTime = DateTime.now();

  List<DateModel> dateList = new List<DateModel>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = colckTime;

    var today = new DateTime(now.year, now.month, now.day);
    var today_1 = new DateTime(now.year, now.month, now.day - 1);
    var today_2 = new DateTime(now.year, now.month, now.day - 2);
    var today_3 = new DateTime(now.year, now.month, now.day - 3);
    var today_4 = new DateTime(now.year, now.month, now.day - 4);
    var today_5 = new DateTime(now.year, now.month, now.day - 5);
    var today_6 = new DateTime(now.year, now.month, now.day - 6);

    dateList.add(DateModel(true, today));
    dateList.add(DateModel(false, today_1));
    dateList.add(DateModel(false, today_2));
    dateList.add(DateModel(false, today_3));
    dateList.add(DateModel(false, today_4));
    dateList.add(DateModel(false, today_5));
    dateList.add(DateModel(false, today_6));

    if (mounted) {
      _dateTime['date'] = colckTime;
      _dateTime['time'] = colckTime;
      _publishSelection(_dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 25.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              alignment: Alignment.topLeft,
              child: Text(
                "When was it?",
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            _sevenDay(),
            Container(
              margin: EdgeInsets.all(16.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Select approximate time",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    alignment: Alignment.topRight,
                    child: Text(new DateFormat.jm().format(colckTime)),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 50.0, right: 50.0, bottom: 16.0),
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildBottomPicker(
                              CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: colckTime,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  setState(() {
                                    colckTime = newDateTime;
                                    _dateTime['time'] = newDateTime;
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: new Clock(
                        circleColor: Colors.white,
                        showBellsAndLegs: false,
                        bellColor: Colors.blueAccent,
                        clockText: ClockText.arabic,
                        showHourHandleHeartShape: false,
                        time: colckTime,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: 150.0,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }

  Widget _sevenDay() {
    return Container(
      height: 90.0,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length,
        itemBuilder: (BuildContext context, int index) {
          return new InkWell(
            onTap: () {
              //print("Click on ${dateList[index].dateTime}");

              setState(() {
                dateList.forEach((element) => element.isSelected = false);
                dateList[index].isSelected = true;
                _dateTime['date'] = dateList[index].dateTime;
              });
            },
            child: new DateItem(dateList[index]),
          );
        },
      ),
    );
  }

  void _publishSelection(Map _dateTime) {
    if (widget.onChanged != null) {
      widget.onChanged(_dateTime);
    }
  }
}

class DateItem extends StatelessWidget {
  final DateModel _item;
  DateItem(this._item);

  _dateItem(DateModel _item) {
    DateTime dateTime = _item.dateTime;
    return Card(
      color: _item.isSelected ? Colors.deepPurple : Colors.white,
      child: Container(
        color: _item.isSelected ? Colors.deepPurple : Colors.white,
        margin: EdgeInsets.all(8.0),
        alignment: Alignment.topCenter,
        height: 100.0,
        width: 100.0,
        child: Column(
          children: <Widget>[
            Text(
              DateFormat.LLLL().format(dateTime),
              style: TextStyle(
                  color: _item.isSelected ? Colors.white : Colors.blueGrey),
            ),
            Text(dateTime.day.toString(),
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: _item.isSelected ? Colors.white : Colors.blueGrey)),
            Text(
              DateFormat.EEEE().format(dateTime),
              style: TextStyle(
                  color: _item.isSelected ? Colors.white : Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _dateItem(_item);
  }
}

class DateModel {
  bool isSelected;
  final DateTime dateTime;
  DateModel(this.isSelected, this.dateTime);
}
