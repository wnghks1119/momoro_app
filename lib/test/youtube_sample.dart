import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YoutubeSample extends StatefulWidget {
  final String userName;
  final String dateString;

  const YoutubeSample(
      {super.key, required this.userName, required this.dateString});

  @override
  State<YoutubeSample> createState() => _YoutubeSampleState();
}

class _YoutubeSampleState extends State<YoutubeSample> {
  CollectionReference ref =
      FirebaseFirestore.instance.collection('YoutubeSample');

  final String ratingTitle = "rating";

  /*
  CollectionReference ref = FirebaseFirestore.instance
      .collection('YoutubeSample')
      .doc('장주환')
      .collection('2023년 9월 5일');
   */

  final TextEditingController titleController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController ratingController = TextEditingController();

  Future<void> _update(DocumentSnapshot documentSnapshot, tempRef) async {
    titleController.text = documentSnapshot['title'];
    desController.text = documentSnapshot['description'];


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
                ),
                 */
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    //labelText: 'description',
                    labelText: documentSnapshot['title'],
                  ),
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
                          .update({"title": title, "description": des});
                      /*
                      ref
                          .doc(documentSnapshot.id)
                          .update({"title": title, "description": des}); */

                      titleController.text = "";
                      desController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text('Update'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _create(tempRef) async {
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

                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: '나 자신 / 배우자 / 아이',
                  ),
                ),
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    //labelText: 'description',
                    labelText: '감사한 일',
                  ),
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
                          .add({"title": title, "description": des});


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
        );
      },
    );
  }

  Future<void> _insert(DocumentSnapshot documentSnapshot, tempRef) async {
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

                TextField(
                  controller: ratingController,
                  decoration: InputDecoration(
                    labelText: '오늘의 점수?',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final String rating = ratingController.text;

                      await tempRef
                          .doc(documentSnapshot.id)
                          .update({"rating": rating});


                      ratingController.text = "";
                      Navigator.of(context).pop();
                    },
                    child: Text('rating 추가'),
                  ),
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
    var tempRef = FirebaseFirestore.instance
        .collection('YoutubeSample')
        .doc(widget.userName)
        .collection(widget.dateString);

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
            "YouTube 영상 변형 연습",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: ref
              .doc(widget.userName)
              .collection(widget.dateString)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return Column(
                children: [
                  Container(
                    //height: 100,
                    child: Text(
                      widget.dateString,
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: streamSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                              streamSnapshot.data!.docs[index];
                        return Card(
                          margin: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 8,
                          ),
                          child: ListTile(
                            title: Text(documentSnapshot['title']),
                            subtitle: Text(documentSnapshot['description']),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      _update(documentSnapshot, tempRef);
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _insert(documentSnapshot, tempRef);
                                    },
                                    icon: Icon(Icons.add_box_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: () {
            _create(tempRef);
          },
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}
