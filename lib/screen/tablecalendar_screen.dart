import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:momoro_app/controller/google_auth.dart';
import 'package:momoro_app/screen/input_text_list_screen.dart';
import 'package:momoro_app/test/youtube_translate.dart';
import 'package:table_calendar/table_calendar.dart';

import '../test/test_input_list_screen.dart';
import '../test/test_screen.dart';
import '../test/youtube_sample.dart';
import 'last_test_screen.dart';
import 'login_after_screen.dart';

class TableCalendarScreen extends StatefulWidget {
  final String userName;
  final String userRef;

  const TableCalendarScreen(
      {super.key, required this.userName, required this.userRef});

  @override
  State<TableCalendarScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<TableCalendarScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('admin');

  DateTime? selectedDay;
  late String selectedDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
        title: Text(
          "Calendar",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<Object>(
            stream: ref.doc(widget.userRef).snapshots(),
            builder: (BuildContext context, snapshot) {
              var docIdx = 0;

              return Column(
                children: [
                  TableCalendar(
                    locale: 'ko_KR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2029, 12, 31),
                    focusedDay: DateTime.now(),
                    onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                      setState(() {
                        this.selectedDay = selectedDay;
                        selectedDate =
                        "${selectedDay.year}년 ${selectedDay
                            .month}월 ${selectedDay.day}일";
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LastTestScreen(
                                dateString: selectedDate,
                                userName: widget.userName,
                                userRef: widget.userRef,
                                year: selectedDay.year,
                                month: selectedDay.month,
                                day: selectedDay.day,
                              ),

                          /*
                        builder: (context) => YoutubeSample(
                          dateString: selectedDate,
                          userName: widget.userName,
                        ), */

                          /*
                        builder: (context) => YoutubeTranslate(
                          dateString: selectedDate,
                          userName: widget.userName,
                        ), */

                          /*
                        builder: (context) => TestScreen(
                          selectedDate: selectedDay,
                          dateString: selectedDate,
                          userName: widget.userName,
                        ), */

                          /*
                        builder: (context) => TestInputListScreen(
                          selectedDate: selectedDay,
                          dateString: selectedDate,
                          userName: widget.userName,
                        ), */

                          /*
                        builder: (context) => InputTextListScreen(
                          selectedDate: selectedDay,
                          userName: widget.userName,
                          userRef: widget.userRef,
                          dateString: selectedDate,
                        ), */
                        ),
                      );
                    },
                    selectedDayPredicate: (DateTime date) {
                      if (selectedDay == null) {
                        return false;
                      }
                      return date.year == selectedDay!.year &&
                          date.month == selectedDay!.month &&
                          date.day == selectedDay!.day;
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      formatButtonVisible: false,
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      weekendTextStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      outsideDaysVisible: false,
                      isTodayHighlighted: false,
                      todayDecoration: BoxDecoration(
                        color: Color(0xFF9FA8DA),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  /*
                  Expanded(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      //margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
                      color: Colors.greenAccent,
                      /*
                      child: ListView.builder(

                      ), */
                    ),
                  ) */
                ],
              );
            }),
      ),
    );
  }
}
