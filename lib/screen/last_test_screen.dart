import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

class LastTestScreen extends StatefulWidget {
  final String userName;
  final String userRef;
  final String dateString;
  final year;
  final month;
  final day;

  const LastTestScreen(
      {super.key,
      required this.userName,
      required this.userRef,
      required this.dateString,
      required this.year,
      required this.month,
      required this.day});

  @override
  State<LastTestScreen> createState() => _LastTestScreenState();
}

class _LastTestScreenState extends State<LastTestScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('admin');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot, tempRef) async {
    titleController.text = documentSnapshot['title'];
    desController.text = documentSnapshot['description'];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: desController,
                    decoration: InputDecoration(
                      //labelText: 'description',
                      labelText: documentSnapshot['title'],
                    ),
                    maxLines: null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final String title = titleController.text;
                        final String des = desController.text;

                        await tempRef
                            .doc(documentSnapshot.id)
                            .update({"description": des});
                        /*
                        ref
                            .doc(documentSnapshot.id)
                            .update({"title": title, "description": des}); */

                        titleController.text = "";
                        desController.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Text('저장'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _getFirstRatingVal(streamSnapshot) {
    if (streamSnapshot.data?.docs.length == 0) {
      return 0.0;
    } else {
      var temp = streamSnapshot.data!.docs;
      List<double> getFirstRatingList = [];
      // 기존 ratingbar 입력값 받는 과정
      for (var ref in temp) {
        var tempDocRef = ref['rating'];
        getFirstRatingList.add(tempDocRef);
      }

      return getFirstRatingList[0];
    }
  }

  void _updateRatingVal(streamSnapshot, ratingVal, tempRef) async {
    var temp = streamSnapshot.data!.docs;
    List<String> getDocRefList = []; // 문서별 문서명 받아오기 위한 리스트
    List<int> idx = [0, 1, 2];

    for (var ref in temp) {
      var tempDocRef = ref.id;
      getDocRefList.add(tempDocRef);
    }

    for (var i in idx) {
      await tempRef.doc(getDocRefList[i]).update({"rating": ratingVal});
    }
  }

  @override
  Widget build(BuildContext context) {
    var tempRef = FirebaseFirestore.instance
        .collection('admin')
        .doc(widget.userRef)
        .collection(widget.year.toString())
        .doc(widget.month.toString())
        .collection(widget.day.toString());

    var offstageIdx;
    var ratingVal = 0.0; // ratingBar 값 변화시킬 때 데이터 저장을 위한 변수
    double firstRatingVal; // ratingBar 초기값 받는 변수

    final String refMy;
    final String refSpouse;
    final String refBaby;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Thank-you Note",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: ref
                .doc(widget.userRef)
                .collection(widget.year.toString()).doc(widget.month.toString()).collection(widget.day.toString())
                .orderBy("title", descending: false) // 리스트뷰 정렬을 위한 코드
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                if (streamSnapshot.data?.docs.length == 0) {
                  offstageIdx = false;
                } else {
                  offstageIdx = true;
                }
                firstRatingVal = _getFirstRatingVal(streamSnapshot);

                return Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Text(
                            widget.dateString,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Offstage(
                      offstage: !offstageIdx,
                      child: RatingBar.builder(
                        initialRating: firstRatingVal,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) async {
                          setState(() {
                            ratingVal = rating;
                          });
                          _updateRatingVal(streamSnapshot, ratingVal, tempRef);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Offstage(
                      offstage: offstageIdx,
                      child: ElevatedButton(
                        onPressed: () async {
                          // 기존 데이터 없는 경우, 초기 감사노트 템플릿 생성 코드
                          await tempRef.add({"title": "나 자신", "description": "", "rating": 0.0});
                          await tempRef.add({"title": "배우자", "description": "", "rating": 0.0});
                          await tempRef.add({"title": "아이", "description": "", "rating": 0.0});
                        },
                        child: Text(
                          "템플릿 생성",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(10)),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.indigo),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !offstageIdx,
                      child: Text(
                        "<감사한 일을 작성해보세요>",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.indigo,
                            width: 1,
                          ),
                        ),
                        child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Card(
                              margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8,),
                              child: ListTile(
                                title: Text(
                                  documentSnapshot['title'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  documentSnapshot['description'],
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          _update(documentSnapshot, tempRef);
                                        },
                                        icon: Icon(Icons.edit),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    /*
                    Offstage(
                      offstage: !offstageIdx,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        color: Colors.green,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            '완료',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                          ),
                        ),
                      ),
                    ), */
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
