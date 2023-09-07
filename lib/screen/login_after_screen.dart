import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momoro_app/screen/login_screen.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

//import '../component/login_widget.dart';

class LoginAfterScreen extends StatefulWidget {
  const LoginAfterScreen({super.key});

  @override
  State<LoginAfterScreen> createState() => _LoginAfterScreenState();
}

class _LoginAfterScreenState extends State<LoginAfterScreen> {
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
              if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                var userRef = snapshot.data?.uid; // 사용자 계정에 따른 document 이름 저장해두는 변수
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 130, 0, 100),
                        child: Text(
                          "${snapshot.data?.displayName}님 환영합니다.",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          //color: Colors.greenAccent,
                          padding: EdgeInsets.only(bottom: 100),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => TableCalendarScreen(
                                        userName: snapshot.data!.displayName.toString(),
                                        userRef: userRef.toString(),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  backgroundColor: Colors.indigo,
                                ),
                                child: Text(
                                  "Calendar Screen",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                width: 20,
                              ),
                              TextButton(
                                onPressed: FirebaseAuth.instance.signOut,
                                child: Text(
                                  "로그아웃",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.grey.withOpacity(0.3)),
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 20)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
