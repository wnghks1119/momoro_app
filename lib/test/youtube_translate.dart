import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

class YoutubeTranslate extends StatefulWidget {
  final String userName;
  final String dateString;

  const YoutubeTranslate(
      {super.key, required this.userName, required this.dateString});

  @override
  State<YoutubeTranslate> createState() => _YoutubeTranslateState();
}

class _YoutubeTranslateState extends State<YoutubeTranslate> {
  CollectionReference ref =
      FirebaseFirestore.instance.collection('YoutubeTranslate');

  var numMy = 0;
  var numSpouse = 0;
  var numBaby = 0;

  /*
  CollectionReference ref = FirebaseFirestore.instance
      .collection('YoutubeTranslate')
      .doc('장주환')
      .collection('2023년 9월 5일');
   */

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

  String _updateDocID(streamSnapshot, tempRef) {
    var temp = streamSnapshot.data!.docs;
    List<String> getDocRefList = []; // 문서별 문서명 받아오기 위한 리스트
    List<int> idx = [0, 1, 2];

    for (var ref in temp) {
      var tempDocRef = ref.id;
      getDocRefList.add(tempDocRef);
    }

    //print(getDocRefList);

    return getDocRefList[0];

    /*
    for (var i in idx) {
      await tempRef.doc(getDocRefList[i]).update({"docID": getDocRefList[i]});
    } */
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
      //var tempDocRef = ref['docID'];
      var tempDocRef = ref.id;
      getDocRefList.add(tempDocRef);
    }

    // return getDocRefList[0];

    for (var i in idx) {
      await tempRef.doc(getDocRefList[i]).update({"rating": ratingVal});
    }
  }

  @override
  Widget build(BuildContext context) {
    var tempRef = FirebaseFirestore.instance
        .collection('YoutubeTranslate')
        .doc(widget.userName)
        .collection(widget.dateString);

    //var existFirstRating = widget.firstRatingVal; // 초기 rating 값 받는 변수

    var offstageIdx;
    var ratingVal = 0.0; // ratingBar 값 변화시킬 때 데이터 저장을 위한 변수
    double firstRatingVal; // ratingBar 초기값 받는 변수
    var getDocRef;

    final String refMy;
    final String refSpouse;
    final String refBaby;

    var tempRes;

    var docRef = ["", "", ""];
    List<double> tempDocRefList = [0, 0, 0]; // ratingBar 초기값 받기 위한 변수

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.indigo,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "YouTube 영상 활용_추가 변형",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: ref
                .doc(widget.userName)
                .collection(widget.dateString)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              /*
              var document = FirebaseFirestore.instance
                  .collection('YoutubeTranslate')
                  .doc(widget.userName)
                  .collection(widget.dateString)
                  .doc('나 자신').get().then((document) =>
              {
               print(document('나 자신'))
              }); */

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

                          //ratingVal = rating;
                          print(ratingVal);
                          print(firstRatingVal);
                          print(firstRatingVal.runtimeType);
                          //print(getDocRef);

                          //print(res);
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
                          await tempRef.add({
                            "title": "나 자신",
                            "description": "",
                            "rating": 0.0
                          });
                          await tempRef.add({
                            "title": "배우자",
                            "description": "",
                            "rating": 0.0
                          });
                          await tempRef.add({
                            "title": "아이",
                            "description": "",
                            "rating": 0.0
                          });
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
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(20),
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

                            docRef[index] = documentSnapshot.id;

                            return Card(
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                                bottom: 8,
                              ),
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
                      /*
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        color: Colors.green,
                        child: ElevatedButton(
                          onPressed: () async {
                            print(ratingVal);

                            await tempRef.doc(docRef[0]).update({"rating": ratingVal, "docID": docRef[0]});
                            await tempRef.doc(docRef[1]).update({"rating": ratingVal, "docID": docRef[1]});
                            await tempRef.doc(docRef[2]).update({"rating": ratingVal, "docID": docRef[2]});


                            //Navigator.of(context).pop();
                            /*
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => TableCalendarScreen(
                                  userName: widget.userName,
                                ),
                              ),
                            ); */
                          },
                          child: Text(
                            'rating 추가',
                            style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsets>(
                                EdgeInsets.all(12)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                          ),
                        ),
                      ), */
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
