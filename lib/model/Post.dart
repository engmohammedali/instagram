import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String profileImg;
  final String username;
  final String description;
  final String imgPost;
  final String uid;
  final String postId;
  final DateTime datePublished;
  final List likes;
  PostData(
      {required this.datePublished,
      required this.description,
      required this.imgPost,
      required this.likes,
      required this.postId,
      required this.profileImg,
      required this.uid,
      required this.username});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'profileImg': profileImg,
      'description': description,
      'imgPost': imgPost,
      'uid': uid,
      'postId': postId,
      'datePublished': datePublished,
      'likes': likes
    };
  }

  
  
   convertSnap2Model(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostData(
      username: snapshot["username"],
      profileImg: snapshot["profileImg"],
      description: snapshot["description"],
      imgPost: snapshot["imgPost"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      likes: snapshot["likes"],
    );
  }
}
