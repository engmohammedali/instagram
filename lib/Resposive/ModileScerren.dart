import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Scerren/AddPost.dart';
import 'package:instagram/Scerren/Home.dart';
import 'package:instagram/Scerren/Profile.dart';
import 'package:instagram/Scerren/Search.dart';
import 'package:instagram/Share/Colore.dart';

class MobileScerren extends StatefulWidget {
  const MobileScerren({super.key});

  @override
  State<MobileScerren> createState() => _MobileScerrenState();
}

class _MobileScerrenState extends State<MobileScerren> {
  var _controller = PageController();
  int currentuser = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CupertinoTabBar(
          onTap: (value) {
            _controller.jumpToPage(value);
            currentuser = value;
            setState(() {});
          },
          backgroundColor: mobileBackgroundColor,
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
              Icons.home,
              color: currentuser == 0 ? primaryColor : secondaryColor,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.search,
              color: currentuser == 1 ? primaryColor : secondaryColor,
            )),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                color: currentuser == 2 ? primaryColor : secondaryColor,
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.favorite,
              color: currentuser == 3 ? primaryColor : secondaryColor,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              Icons.person,
              color: currentuser == 4 ? primaryColor : secondaryColor,
            )),
          ]),
      body: PageView(
        onPageChanged: (value) {},
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Home(),
          Search(),
          AddPost(),
          Center(child: Text("Favorite")),
          Profile(uid: FirebaseAuth.instance.currentUser!.uid,)
        ],
      ),
    );
  }
}
