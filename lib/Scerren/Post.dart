import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Firebase_servse/FirebaaseStore/AddPostDatabase.dart';
import 'package:instagram/Scerren/Comments.dart';
import 'package:instagram/Share/Colore.dart';
import 'package:intl/intl.dart';

import '../Share/heart_animation.dart';

class PostWidgth extends StatefulWidget {
  final data;
  final double sizeSeccrean;

  PostWidgth({super.key, required this.data, required this.sizeSeccrean});

  @override
  State<PostWidgth> createState() => _PostWidgthState();
}

class _PostWidgthState extends State<PostWidgth> {
  int countComments = 0;
  bool islikeFavorite = false;
  bool isLikeAnimating = false;

  clickHartFaviret() async {
    setState(() {
      isLikeAnimating = true;
    });
    await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.data['postId'])
        .update({
      "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
    });
  }

  getCommentCount() async {
    try {
      QuerySnapshot countCommentdocs = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.data['postId'])
          .collection('comments')
          .get();

      countComments = countCommentdocs.docs.length;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  showmodel() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            FirebaseAuth.instance.currentUser!.uid == widget.data["uid"]
                ? SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      FirebaseFirestore.instance
                          .collection("posts")
                          .doc(widget.data["postId"])
                          .delete();
                    },
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Deleted Post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )
                : SimpleDialogOption(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Can Not Deleted Post",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.all(20),
              child: Text(
                "Cansel",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getCommentCount();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mobileBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: widget.sizeSeccrean > 600 ? widget.sizeSeccrean / 6 : 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(
                          // widget.snap["profileImg"],
                          widget.data['profileImg'].toString()),
                    ),
                    SizedBox(
                      width: 17,
                    ),
                    Text(
                      // widget.snap["username"],
                      widget.data['username'],
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      showmodel();
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await clickHartFaviret();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  // widget.snap["postUrl"],
                  widget.data['imgPost'],
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Center(child: CircularProgressIndicator()));
                  },
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 111,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: widget.data['likes']
                          .contains(FirebaseAuth.instance.currentUser!.uid),
                      smallLike: true,
                      child: IconButton(
                        onPressed: () async {
                          await FirestoreMethods()
                              .AddLiskePost(data: widget.data);
                        },
                        icon: widget.data['likes'].contains(
                                FirebaseAuth.instance.currentUser!.uid)
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentsScreen(
                                      data: widget.data,
                                      isview: true,
                                    )));
                      },
                      icon: Icon(
                        Icons.comment_outlined,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.bookmark_outline),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              width: double.infinity,
              child: Text(
                "${widget.data['likes'].length.toString()}  "
                "${widget.data['likes'].length > 1 ? "likes" : "like"}",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
              )),
          Row(
            children: [
              SizedBox(
                width: 9,
              ),
              Text(
                // "${widget.snap["username"]}",
                widget.data['username'],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 189, 196, 199)),
              ),
              SizedBox(
                width: 9,
              ),
              Text(
                // " ${widget.snap["description"]}",
                widget.data['description'],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 189, 196, 199)),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            data: widget.data,
                            isview: false,
                          )));
            },
            child: Container(
                margin: EdgeInsets.fromLTRB(10, 13, 9, 10),
                width: double.infinity,
                child: Text(
                  "view all $countComments comments",
                  style: TextStyle(
                      fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                  textAlign: TextAlign.start,
                )),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 0, 9, 10),
              width: double.infinity,
              child: Text(
                DateFormat("MMMM d,y")
                    .format(widget.data['datePublished'].toDate()),
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(214, 157, 157, 165)),
                textAlign: TextAlign.start,
              )),
        ],
      ),
    );
  }
}
