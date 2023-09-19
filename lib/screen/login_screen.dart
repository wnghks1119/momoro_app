import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../controller/google_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CollectionReference ref = FirebaseFirestore.instance.collection('admin');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.03,
          horizontal: MediaQuery.of(context).size.width * 0.1,
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  margin: EdgeInsets.symmetric(
                      //vertical: 30,
                      //horizontal: 30,
                      ),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        "assets/images/momoro_logo_text.png",
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  //horizontal: 10.0,
                  //vertical: 15.0,
                  vertical: MediaQuery.of(context).size.height * 0.03,
                ),
                child: Column(
                  children: [
                    Text(
                      "Create and Manage",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'NotoSans',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Your Thank-you Notes",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  signInWithGoogle(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Google Login',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'NotoSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                   Image.asset(
                     "assets/images/google.png",
                     height: MediaQuery.of(context).size.width * 0.08,
                   ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(
                      MediaQuery.of(context).size.height * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  backgroundColor: Colors.indigo,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
