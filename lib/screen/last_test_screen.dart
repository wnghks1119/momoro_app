import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

class LastTestScreen extends StatefulWidget {
  final String userName;
  final String userRef;
  final String dateString;
  final selectedDay;
  final year;
  final month;
  final day;

  const LastTestScreen(
      {super.key,
      required this.userName,
      required this.userRef,
      required this.dateString,
      required this.selectedDay,
      required this.year,
      required this.month,
      required this.day});

  @override
  State<LastTestScreen> createState() => _LastTestScreenState();
}

class _LastTestScreenState extends State<LastTestScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('admin');

  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot, tempRef) async {
    var tempTitle;

    if(documentSnapshot['title'] == "타인") {
      tempTitle = "타인 (배우자, 부모님, 친구 등)";
    } else {
      tempTitle = documentSnapshot['title'];
    }


    //titleController.text = documentSnapshot['title'];
    desController.text = documentSnapshot['description'];

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Scrollbar(
                      child: TextField(
                        controller: desController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          //labelText: 'description',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.indigo,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.indigo,
                            ),
                          ),
                          //labelText: documentSnapshot['title'],
                          labelText: tempTitle,
                          labelStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w500,
                            color: _focusNode.hasFocus ? Colors.indigo : Colors.grey,
                          ),
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final String title = titleController.text;
                          final String des = desController.text;

                          await tempRef
                              .doc(documentSnapshot.id)
                              .update({"description": des});

                          titleController.text = "";
                          desController.text = "";
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '저장',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'NotoSans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: Colors.indigo,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                  ],
                ),
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
              fontSize: 20.0,
              fontFamily: 'NotoSans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: ref
                .doc(widget.userRef)
                .collection(widget.year.toString())
                .doc(widget.month.toString())
                .collection(widget.day.toString())
                .orderBy("idx", descending: false) // 리스트뷰 정렬을 위한 코드
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
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.03,
                          ),
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Text(
                            "${widget.dateString} ${DateFormat.EEEE('ko').format(widget.selectedDay)}",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Offstage(
                      offstage: !offstageIdx,
                      child: RatingBar.builder(
                        initialRating: firstRatingVal,
                        minRating: 0.5,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.height * 0.005,
                        ),
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
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Offstage(
                      offstage: offstageIdx,
                      child: Container(
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.03,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            // 기존 데이터 없는 경우, 초기 감사노트 템플릿 생성 코드
                            await tempRef.add({
                              "idx": 1,
                              "title": "나 자신",
                              "description": "",
                              "rating": 0.0
                            });
                            await tempRef.add({
                              "idx": 2,
                              "title": "타인",
                              "description": "",
                              "rating": 0.0
                            });
                            await tempRef.add({
                              "idx": 3,
                              "title": "아이",
                              "description": "",
                              "rating": 0.0
                            });
                          },
                          child: Text(
                            "템플릿 생성",
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'NotoSans',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.1,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                          ),
                        ),
                      ),
                    ),
                    Offstage(
                      offstage: !offstageIdx,
                      child: Text(
                        "<감사한 일 작성>",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'NotoSans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05,
                          right: MediaQuery.of(context).size.width * 0.05,
                          top: MediaQuery.of(context).size.height * 0.02,
                          bottom: MediaQuery.of(context).size.width * 0.15,
                        ),
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                        ),
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
                            var titleOther = '타인';
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.03,
                              ),
                              child: ListTile(
                                title: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  child: Text(
                                    documentSnapshot['title'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                subtitle: Text(
                                  documentSnapshot['description'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'NotoSans',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                ),
                                trailing: SizedBox(
                                  width: 50,
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
