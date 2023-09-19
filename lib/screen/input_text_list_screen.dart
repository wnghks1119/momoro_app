import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:momoro_app/app.dart';
import 'package:momoro_app/controller/google_auth.dart';
import 'package:momoro_app/screen/modify_screen.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

import '../test/test_screen.dart';
import 'add_screen.dart';

class InputTextListScreen extends StatefulWidget {
  final String userRef;
  final String userName;
  final DateTime selectedDate;
  final String dateString;

  const InputTextListScreen(
      {required this.selectedDate,
      super.key,
      required this.userName,
      required this.userRef,
      required this.dateString});

  @override
  State<InputTextListScreen> createState() => _InputTextListScreenState();
}

class _InputTextListScreenState extends State<InputTextListScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  /*
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');
   */

  late String title;
  late String des;

  @override
  Widget build(BuildContext context) {
    var tempRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userRef)
        .collection(widget.dateString);

    final List<int> number = <int>[1, 2, 3];
    final List<String> title = <String>['나 자신', '배우자', '아이'];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            /*
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => TableCalendarScreen(),
              ),
            ); */
          },
        ),
        title: Text(
          "Thank-you Note",
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
      ),
      body: StreamBuilder(
          stream:
              ref.doc(widget.userRef).collection(widget.dateString).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Text(
                            "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일 "
                            "${DateFormat.EEEE('ko').format(widget.selectedDate)}",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RatingBar.builder(
                    //initialRating: 3,
                    minRating: 0.5,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Expanded(
                    child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final String? idx =
                            streamSnapshot.data?.docs.firstOrNull.toString();
                        final String? tempTitle = streamSnapshot
                            .data?.docs.firstOrNull?.id
                            .toString();

                        String? description = '';
                        final myRef = ref
                            .doc(widget.userRef)
                            .collection(widget.dateString)
                            .doc('배우자').get().then((value) =>
                        {
                                if(value == null) {
                                  description = null,
                                } else {
                                  description = value['description'],
                                }
                        });


                        /*
                        final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index]; */

                        return Card(
                          child: Container(
                            height: 70,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 20.0,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 25.0,
                            ),
                            decoration: BoxDecoration(
                              //color: Colors.amberAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${number[index]}. ${title[index]}",
                                  style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print("------------------------------");

                                      print(streamSnapshot.data?.docs.length); // 문서 갯수
                                      print(streamSnapshot.data?.docs.firstOrNull); // 이 값이 null이 아니면 기존에 입력한 데이터 존재한다는 의미
                                      print(streamSnapshot.data?.docs.firstOrNull?.id); //'title' 이름 (없으면 null)
                                      print(tempTitle);
                                      print(myRef);
                                      print(description);

                                      print("------------------------------");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AddScreen(
                                            // 기존에 입력한 데이터 없는 경우
                                            index: index,
                                            selectedDate: widget.selectedDate,
                                            userName: widget.userName,
                                            userRef: widget.userRef,
                                          ),
                                        ),
                                      );

                                      /*
                                      if(streamSnapshot.data!.docs.length == 0) {  // 항목이
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AddScreen(
                                              // 기존에 입력한 데이터 없는 경우
                                              index: index,
                                              selectedDate: widget.selectedDate,
                                              userName: widget.userName,
                                              userRef: widget.userRef,
                                            ),
                                          ),
                                        );
                                      } else {  // 3가지 항목 중 어떤 것을 수정할 것인지에 대해 구분 필요
                                        //final String tempName =
                                        final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];



                                        if(documentSnapshot['title'] == '나 자신') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Temp(),
                                            ),
                                          );
                                        } else if (documentSnapshot['title'] == '배우자') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TempWife(),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TempBaby(),
                                            ),
                                          );
                                        }
                                      } */
                                    },
                                    child: Text(
                                      "입력 / ${index}",
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      primary: Colors.white,
                                      textStyle: TextStyle(
                                        fontSize: 22,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 13, horizontal: 17),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                        /*
                        return Card(
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              "${number[index]}. ${title[index]}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //subtitle: Text(documentSnapshot['description']),
                            trailing: ElevatedButton(
                              onPressed: () {
                                if(streamSnapshot.data!.docs.length == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddScreen(
                                        // 기존에 입력한 데이터 없는 경우
                                        index: index,
                                        selectedDate: widget.selectedDate,
                                        userName: widget.userName,
                                        userRef: widget.userRef,
                                      ),
                                    ),
                                  );
                                } else {  // 3가지 항목 중 어떤 것을 수정할 것인지에 대해 구분 필요
                                  if(documentSnapshot['title'].toString() == "나 자신") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Temp(),
                                      ),
                                    );
                                  } else if (documentSnapshot['title'].toString() == "배우자") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TempWife(),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TempBaby(),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                "입력",
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.indigo,
                                primary: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 22,
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 13, horizontal: 17),
                              ),
                            ),

                            /*
                          SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        // 저장된 데이터 유무에 따라 다른 화면으로 전환되도록 변경(if문 활용)
                                        builder: (context) => AddScreen(
                                          // 기존에 입력한 데이터 없는 경우
                                          index: index,
                                          selectedDate: widget.selectedDate,
                                          userName: widget.userName,
                                          userRef: widget.userRef,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ), */
                          ),
                        ); */
                      },
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
