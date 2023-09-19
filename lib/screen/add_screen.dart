import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  // 어떤 항목 입력하는 건지 구분하는 지표
  final int index;
  final String userRef;
  final DateTime selectedDate;
  final String userName;

  const AddScreen({super.key, required this.index, required this.selectedDate, required this.userName, required this.userRef});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late String title;
  late String des;
  late String date;

  @override
  Widget build(BuildContext context) {
    final List<String> list = <String>['나 자신', '배우자', '아이'];
    title = list[widget.index];
    int num = widget.index + 1; // list 값 print 위한 정보
    date =
        "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일";

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.indigo,
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: add,
                      child: Text(
                        '저장',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.indigo,
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Form(
                  child: Column(
                    children: [
                      Text(
                        "${num}. ${title}",
                        style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: '감사했던 일을 작성해보세요.',
                          ),
                          style: TextStyle(
                            fontSize: 24.0,
                          ),
                          onChanged: (_val) {
                            des = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() {
    //CollectionReference forName = FirebaseFirestore.instance.collection('users');

    //final String name = forName.doc(FirebaseAuth.instance.currentUser?.uid)['name'].toString();

    /*
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("${date}"); */


    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userRef)
        .collection("${date}");

    var data = {
      'title': title,
      'description': des,
      //'created': DateTime.now(),
    };

    ref.doc(title).set(data);

    Navigator.pop(context);
  }
}
