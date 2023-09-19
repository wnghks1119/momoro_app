import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'input_text_list_screen.dart';

class ModifyScreen extends StatefulWidget {
  final int index;
  final DateTime selectedDate;
  final String date;

  const ModifyScreen({super.key,
    required this.index,
    required this.selectedDate,
    required this.date});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  late String title;
  //late Map data;
  //late String des;

  @override
  Widget build(BuildContext context) {
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(widget.date);


    final List<String> list = <String>['나 자신', '배우자', '아이'];
    title = list[widget.index];

    var data;
    ref.doc(title).get().
    then((DocumentSnapshot doc) => {
      data = doc.data() as Map<String, dynamic>,
    },
      onError: (e) => print("Error getting document: $e"),
    );

    /*
    Object? data = ref.doc(title).get();
    var des = '';
    ref.doc(title).get().then((DocumentSnapshot ds) =>
    {
      des = ds['description'],
      //print(des),
    }); */


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
            "Test Screen",
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        body: Center(
          child: Text(
            "${data}",

          ),
        ),

        /*
        FutureBuilder(
          future: ref.doc(title).get(),
          builder: (context, snapshot) {
            data = snapshot.data!.data();
            return Container(
              child: Center(
                child: Text(
                  "${data}",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            );
          },
        ), */
      ),
    );
  }

  String read() {
    final CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(widget.date);

    ref.doc(title).get().
      then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );


    /*
    CollectionReference ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("${date}"); */

    //ref.doc(title).get().then((value) => {print(value.data())});

    var result = '';
    var data = ref.doc(title).get();
    ref.doc(title).get().then((value) =>
    {
      result = value['description'],
      print(result),
    });
    return result;

    /*
    if(data.exists) {
      ref.doc(title).get().then((value) => {
        result = value['description'],
        print(result),
      });
    } else {
      print("No Data !");
    } */

    //Navigator.pop(context);
  }
}
