import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../helper/GroupService.dart';
import '../auth/databaseHelper.dart';

class MemberScreen extends StatefulWidget {

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FirebaseAuth auth =FirebaseAuth.instance;
  List<String> membersList =[];
  List <String> groupName = [];

  void getGroupName() async {

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(auth.currentUser!.uid).child('groups');
    userRef.onValue.listen((DatabaseEvent event){
      if (event.snapshot.exists) {
        final List<dynamic> data = event.snapshot.value as List<dynamic>;
        setState(() {
          groupName = List<String>.from(data);
        });
      } else {
        setState(() {
          groupName = "Name not found!" as List<String>;
        });
      }

    });
  }
  void getGrouMember()async
  {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('groups')
        .child(groupName as String)
        .child('membersList');
    databaseReference.onValue.listen((DatabaseEvent event){
      if (event.snapshot.exists){
        final List<dynamic>? groupList = event.snapshot.value as List<dynamic>?;
        if(groupList!= null){
          setState(() {
            membersList = groupList.cast<String>();
          });
        } else {
          setState(() {
            membersList = [];
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getGroupName();
    getGrouMember();
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Container(
              child: ListView.builder(
                  itemCount: membersList.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                        child: ListTile(
                          title: Text(membersList[index],style: textTheme.headlineSmall),
                          leading: CircleAvatar(
                            child: Text(membersList[index][0],style: textTheme.headlineSmall),
                          ),
                        )
                    );
                  }),
            )
        ),
      ),
    );
  }
}
