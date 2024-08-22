// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Firebase_servse/FirebaaseStore/AddPostDatabase.dart';
import 'package:instagram/Provider/UserProvider.dart';
import 'package:instagram/Share/Colore.dart';
import 'package:instagram/Share/dercorationTextFormFiled.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final Map data;
  bool isview;
  CommentsScreen({Key? key, required this.data, required this.isview})
      : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool colorSendController = false;

  var controllercomments = TextEditingController();
  @override
  void initState() {
    controllercomments.addListener(() {
      if (controllercomments.text.length == 1) {
        colorSendController = true;
        setState(() {});
      } else if (controllercomments.text.isEmpty) {
        colorSendController = false;
        setState(() {});
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allDataFromDB = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.data['postId'])
                  .collection('comments')
                  .orderBy("date")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(12, 12, 0, 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(125, 78, 91, 110),
                                ),
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(data['profileuser']),
                                  radius: 26,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(data['username'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17)),
                                      SizedBox(
                                        width: 11,
                                      ),
                                      Text(data['textcomments'],
                                          style: const TextStyle(fontSize: 16))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                      DateFormat('MMM d, ' 'y')
                                          .format(data["date"].toDate()),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.favorite))
                        ],
                      );
                    }).toList(),
                  ),
                );
              }),
          Visibility(
            visible: widget.isview,
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(125, 78, 91, 110),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(allDataFromDB!.url),
                      radius: 26,
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                        controller: controllercomments,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: decorationTextfield.copyWith(
                            hintText: "Comment as  ${allDataFromDB.username}  ",
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  await FirestoreMethods().uploadComments(
                                      textcomments: controllercomments.text,
                                      postId: widget.data['postId'],
                                      username: allDataFromDB.username,
                                      uid: allDataFromDB.uid,
                                      url: allDataFromDB.url);
                                  controllercomments.clear();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: controllercomments.text.isEmpty
                                      ? Colors.white
                                      : Colors.blueAccent,
                                )))),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
