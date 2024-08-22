import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Provider/UserProvider.dart';
import 'package:instagram/Resposive/ModileScerren.dart';
import 'package:instagram/Resposive/Resposive.dart';
import 'package:instagram/Resposive/WebScerren.dart';
import 'package:instagram/Scerren/Login.dart';
import 'package:instagram/Share/ShowSnackBar.dart';
import 'package:instagram/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) {
          return UserProvider();
        },
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return showSnackBar(context, "Something went wrong");
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasData) {
                    return Resposive(
                      MobileScerren: MobileScerren(),
                      WebScerren: Webscerren(),
                    );
                  } else {
                    return Login();
                  }
                })));
  }
}
