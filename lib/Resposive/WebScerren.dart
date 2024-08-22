import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/Scerren/AddPost.dart';
import 'package:instagram/Scerren/Favorite.dart';
import 'package:instagram/Scerren/Home.dart';
import 'package:instagram/Scerren/Profile.dart';
import 'package:instagram/Scerren/Search.dart';
import 'package:instagram/Share/Colore.dart';

class Webscerren extends StatefulWidget {
  const Webscerren({super.key});

  @override
  State<Webscerren> createState() => _WebscerrenState();
}

class _WebscerrenState extends State<Webscerren> {
  var _controllernetpage = PageController();
  int page = 0;
  navigatorPage(int index) {
    _controllernetpage.jumpToPage(index);
    setState(() {
      page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset(
          'assets/logo/instagram.svg',
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                navigatorPage(0);
                setState(() {
                  page = 0;
                });
              },
              icon: Icon(
                Icons.home,
                color: page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigatorPage(1);
              },
              icon: Icon(Icons.search,
                  color: page == 1 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigatorPage(2);
              },
              icon: Icon(Icons.comment_outlined,
                  color: page == 2 ? primaryColor : secondaryColor)),
          IconButton(
              onPressed: () {
                navigatorPage(3);
              },
              icon: Icon(
                Icons.favorite_border,
                color: page == 3 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: () {
                navigatorPage(4);
              },
              icon: Icon(
                Icons.person,
                color: page == 4 ? primaryColor : secondaryColor,
              )),
        ],
      ),
      body: PageView(
        controller: _controllernetpage,
        children: [
          Home(),
          Search(),
          AddPost(),
          Favorite(),
          Profile(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}
