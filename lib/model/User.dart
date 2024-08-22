import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String username;
  String email;
  String password;
  String title;
  String url;
  String uid;
  List followers;
  List following;
  UserData(
      {required this.email,
      required this.password,
      required this.title,
      required this.username,
      required this.url,
      required this.uid,
      required this.following,
      required this.followers});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'title': title,
      'url': url,
      'uid': uid,
      'following': [],
      'followers': []
    };
  }
   static    convertSnap2Model(DocumentSnapshot snap) {
 var snapshot = snap.data() as Map<String, dynamic>;
 return UserData(
  email: snapshot["email"],
  username: snapshot["username"], password:  snapshot["password"], title:  snapshot["title"], url:  snapshot["url"], uid:  snapshot["uid"], following: snapshot["following"], followers: snapshot["followers"],);
 }

}
