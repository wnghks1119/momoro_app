import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? selectedDay;
  late String selectedDate;

  // 캘린더 아래 리스트 만들 때 기존에 저장되어 있던 데이터 전달받기 위한 변수들

  late String descMy;
  late String descSpouse;
  late String descBaby;
  late double rating;

  /*
  List<String> oldTitleData = ["", "", ""];
  List<String> oldDesData = ["", "", ""];

  var idx = true; // 선택한 날에 데이터 있는지 파악하기 위한 변수
   */

  CollectionReference ref = FirebaseFirestore.instance.collection('admin');
  List<Event> _events = []; // 기존에 저장된 데이터 표시를 위한 변수

  /*
  Future<void> _fetchMemoData(year, month, day) async {
    String documentPath = 'admin/${year.toString()}/${month.toString()}/${day.toString()}';
    QuerySnapshot querySnapshot = await ref
        .doc(userRef)
        .collection(year.toString())
        .doc(month.toString())
        .collection(day.toString())
        .doc(documentPath)
        .get().then((docSnapshot) {
      if (docSnapshot.exists) {  // querySnapshot.docs에 메모 데이터가 들어있음
        // 메모 데이터가 존재하면 처리
        descMy = docSnapshot.get('title');
        //descSpouse = docSnapshot.get('title');
        //descBaby = docSnapshot.get('title');
        rating = docSnapshot.get('rating');
      }
      else
    });

  } */


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
            fontSize: 20.0,
            fontFamily: 'NotoSans',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, dynamic event) {
                if (event.isNotEmpty) {
                  return Container(
                    width: 35,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  );
                }
              }, dowBuilder: (context, day) {
                if (day.weekday == DateTime.sunday) {
                  return Center(
                    child: Text(
                      DateFormat('E', 'ko_KR').format(day),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  );
                } else if (day.weekday == DateTime.saturday) {
                  return Center(
                    child: Text(
                      DateFormat('E', 'ko_KR').format(day),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.indigoAccent,
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Text(
                      DateFormat('E', 'ko_KR').format(day),
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              }, defaultBuilder: (context, date, events) {
                if (date.weekday == DateTime.sunday) {
                  // 일요일인 경우 텍스트 색상을 붉은색으로 변경
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 15,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500, // 원하는 스타일 설정
                      ),
                    ),
                  );
                } else if (date.weekday == DateTime.saturday) {
                  // 일요일인 경우 텍스트 색상을 붉은색으로 변경
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontSize: 15,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500, // 원하는 스타일 설정
                      ),
                    ),
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500, // 원하는 스타일 설정
                      ),
                    ),
                  );
                }
              }),
              locale: 'ko_KR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2029, 12, 31),
              focusedDay: DateTime.now(),
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                setState(() {
                  this.selectedDay = selectedDay;
                  selectedDate =
                      "${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일";
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LastTestScreen(
                      dateString: selectedDate,
                      userName: widget.userName,
                      userRef: widget.userRef,
                      selectedDay: selectedDay,
                      year: selectedDay.year,
                      month: selectedDay.month,
                      day: selectedDay.day,
                    ),
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
              daysOfWeekHeight: MediaQuery.of(context).size.height * 0.03,
              headerStyle: HeaderStyle(
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w700,
                ),
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: true,
                outsideTextStyle: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 16,
                  fontFamily: 'NotoSans',
                  fontWeight: FontWeight.w500,
                ),
                isTodayHighlighted: selectedDay == null ? true : false,
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
          ],
        ),
      ),
    );
  }
}

class Event {
  final String descMy;
  final String descOther;
  final String descBaby;
  final double rating;

  Event(this.descMy, this.descOther, this.descBaby, this.rating);
}
