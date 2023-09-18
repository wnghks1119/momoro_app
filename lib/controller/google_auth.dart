import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../screen/login_after_screen.dart';

GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users =
    FirebaseFirestore.instance.collection('admin'); // firestore 저장을 위한 경로 생성

late String userRef; // 로그인한 계정이 저장되는 문서명 저장하기 위한 변수

Future signInWithGoogle(context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = await GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await auth.signInWithCredential(credential);

      final User? user = authResult.user;

      var userData = await {
        'name': googleSignInAccount.displayName,
        'provider': 'google',
        'photoUrl': googleSignInAccount.photoUrl,
        'email': googleSignInAccount.email,
      };

      users.doc(user?.uid).get().then(
        (doc) async {
          if (doc.exists) {
            await doc.reference.update(userData);
            /*
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginAfterScreen(),
              ),
            ); */
          } else {
            await users.doc(user?.uid).set(userData);
            /*
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginAfterScreen(),
              ),
            ); */
          }
        },
      );
    }
  } catch (PlatformException) {
    print(PlatformException);
    print("Sign is note successful !");
  }
}

Future<void> GoogleLogout() async {
  await googleSignIn.disconnect();
  await FirebaseAuth.instance.signOut();
}
