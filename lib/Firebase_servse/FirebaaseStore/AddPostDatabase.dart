import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/Firebase_servse/Storge.dart';
import 'package:instagram/Share/ShowSnackBar.dart';
import 'package:instagram/model/Post.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPost({
    required imgName,
    required imgPath,
    required description,
    required profileImg,
    required username,
    required context,
  }) async {
    String message = "ERROR => Not starting the code";

    try {
// ______________________________________________________________________

      String urlll = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgPosts/${FirebaseAuth.instance.currentUser!.uid}');

// _______________________________________________________________________
// firebase firestore (Database)
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');

      String newId = const Uuid().v1();

      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: urlll,
          likes: [],
          profileImg: profileImg,
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username);

      message = "ERROR => erroe hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee";
      posts
          .doc(newId)
          .set(postt.toMap())
          .then((value) => print("done................"))
          .catchError((error) => print("Failed to post: $error"));

      message = " Posted successfully ♥ ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      print(e);
    }

    showSnackBar(context, message);
  }

  uploadComments(
      {required textcomments,
      required postId,
      required username,
      required uid,
      required url}) async {
    if (textcomments.isNotEmpty) {
      String commentsid = const Uuid().v1();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentsid)
          .set({
        'commentsid': commentsid,
        'textcomments': textcomments,
        'date': DateTime.now(),
        'username': username,
        'uid': uid,
        'profileuser': url
      });
    }
  }

  AddLiskePost({required Map data}) async {
    try {
      if (data['likes'].contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(data['postId'])
            .update({
          'likes':
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(data['postId'])
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
