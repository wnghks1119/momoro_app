import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momoro_app/screen/login_screen.dart';
import 'package:momoro_app/screen/tablecalendar_screen.dart';

import '../controller/google_auth.dart';

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
                var userRef =
                    snapshot.data?.uid; // 사용자 계정에 따른 document 이름 저장해두는 변수
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      //image: AssetImage("assets/images/mobile_login_bg.png"),
                      image: AssetImage("assets/images/login_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.15,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              //color: Colors.amberAccent,
                              height: MediaQuery.of(context).size.height * 0.45,
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.2,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    "'${snapshot.data?.displayName}'님",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  Text(
                                    "환영합니다.",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'NotoSans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(), // 배경 로고 보이기 위한 공간
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              //color: Colors.purpleAccent,
                              //padding: EdgeInsets.only(top: 100),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TableCalendarScreen(
                                            userName: snapshot.data!.displayName
                                                .toString(),
                                            userRef: userRef.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      backgroundColor: Colors.indigo,
                                    ),
                                    child: Text(
                                      "Calendar Screen",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  TextButton(
                                    //onPressed: FirebaseAuth.instance.signOut,
                                    onPressed: GoogleLogout,
                                    child: Text(
                                      "로그아웃",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontFamily: 'NotoSans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                      backgroundColor:
                                          Colors.grey.shade300,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
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
