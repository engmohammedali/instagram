import 'package:flutter/material.dart';
import 'package:instagram/Provider/UserProvider.dart';
import 'package:provider/provider.dart';

class Resposive extends StatefulWidget {
  final MobileScerren;
  final WebScerren;
  const Resposive(
      {super.key, required this.MobileScerren, required this.WebScerren});

  @override
  State<Resposive> createState() => _ResposiveState();
}

class _ResposiveState extends State<Resposive> {
   getDataFromDB() async {
 UserProvider userProvider = Provider.of(context, listen: false);
 await userProvider.refreshUser();
 }
 
 
 @override
 void initState() {
    super.initState();
    getDataFromDB();
 }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext, BoxConstraints) {
      if (BoxConstraints.maxWidth > 600) {
        return widget.WebScerren;
      } else {
        return widget.MobileScerren;
      }
    });
  }
}
