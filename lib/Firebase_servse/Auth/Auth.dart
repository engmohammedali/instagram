import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Firebase_servse/Storge.dart';
import 'package:instagram/Resposive/ModileScerren.dart';
import 'package:instagram/Resposive/Resposive.dart';
import 'package:instagram/Resposive/WebScerren.dart';
import 'package:instagram/Share/ShowSnackBar.dart';
import 'package:instagram/model/User.dart';

class FirebaseFunction {
  login({required email, required password, required context}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Resposive(
                  MobileScerren: MobileScerren(),
                  WebScerren: Webscerren(),
                )),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "${e.code}");
    }
  }

  register(
      {required email,
      required password,
      required context,
      required title,
      required username,
      required imgPath,
      required imgname}) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      //-------------------------------------------------------------------------

      String url = await getImgURL(
      
        
          imgPath: imgPath, imgName: imgname, folderName:  ' ProfileImg/${credential.user!.uid}');
//------------------------------------------------------------------------------------

      UserData user = UserData(
          email: email,
          password: password,
          title: title,
          username: username,
          url: url,
          uid: credential.user!.uid,
          following: [],
          followers: []);

      //---------------------------------------------------------------------
      users
          .doc(credential.user!.uid)
          .set(user.toMap())
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Resposive(
                  MobileScerren: MobileScerren(),
                  WebScerren: Webscerren(),
                )),
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "${e.code}");
    }
  }

  Future<UserData> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    return UserData.convertSnap2Model(snap);
  }
}
