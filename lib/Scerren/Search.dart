import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram/Scerren/Profile.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(hintText: "Search"),
            controller: usernameController,
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: usernameController.text)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Profile(
                                      uid: snapshot.data!.docs[0]['uid'])));
                        },
                        leading: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              NetworkImage(snapshot.data!.docs[0]['url']),
                        ),
                        title: Text(
                          snapshot.data!.docs[0]['username'],
                          style: TextStyle(fontSize: 22),
                        ),
                      ),
                    );
                  });
            }

            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          },
        ));
  }
}
