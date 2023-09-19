import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:momoro_app/app.dart';
import 'package:momoro_app/screen/modify_screen.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

import '../screen/add_screen.dart';
import '../test/test_screen.dart';

class TestInputListScreen extends StatefulWidget {
  final String userName;
  final DateTime selectedDate;
  final String dateString;

  const TestInputListScreen(
      {required this.selectedDate,
      super.key,
      required this.dateString,
      required this.userName});

  @override
  State<TestInputListScreen> createState() => _TestInputListScreenState();
}

class _TestInputListScreenState extends State<TestInputListScreen> {
  //CollectionReference ref = FirebaseFirestore.instance.collection('items');
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc('장주환')
      .collection('2023년 9월 1일');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();

  Future<void> _update(documentSnapshot) async {
    titleController.text = documentSnapshot['title'];
    desController.text = documentSnapshot['description'];

    //print(FirebaseAuth.instance.currentUser?.uid);
    //print(widget.dateString);

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
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
                /*
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'title',
                  ),
                ), */
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    //labelText: 'description',
                    labelText: documentSnapshot['tilte'],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final String title = titleController.text;
                    final String des = desController.text;

                    ref
                        .doc(documentSnapshot.id)
                        .update({"title": title, "description": des});
                    /*
                    ref
                        .doc(widget.userName)
                        .collection(widget.dateString)
                        .doc(documentSnapshot.id)
                        .update({"title": title, "description": des}); */
                    titleController.text = "";
                    desController.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<int> number = <int>[1, 2, 3];
    //final List<String> title = <String>['나 자신', '배우자', '아이'];
    final String date =
        "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일";

    /*
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(date);
     */

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
        stream: ref.snapshots(),
        /*
        ref
            .doc(widget.userName)
            .collection(widget.dateString)
            .snapshots(), */
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    //height: 100,
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
                  Container(
                    //height: 100,
                    child: Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
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
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        child: ListTile(
                          title: Text(
                            "${index + 1}. ${documentSnapshot['title']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            documentSnapshot['description'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    //print(FirebaseAuth.instance.currentUser?.uid);
                                    //print(widget.dateString);
                                    print(documentSnapshot);

                                    print(streamSnapshot);
                                    print(streamSnapshot.data);
                                    print(streamSnapshot.data!.docs);
                                    print(ref);
                                    /*
                                    print(ref
                                        .doc(widget.userName)
                                        .collection(widget.dateString));
                                    print(ref
                                        .doc(widget.userName)
                                        .collection(widget.dateString)
                                        .snapshots());
                                    print(ref
                                        .doc(widget.userName)
                                        .collection(widget.dateString)
                                        .get());
                                    print(streamSnapshot);
                                    print(streamSnapshot.data);
                                    print(streamSnapshot.data!.docs);
                                    print(ref);
                                     */
                                    _update(documentSnapshot);
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
                ],
              ),
            );
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
