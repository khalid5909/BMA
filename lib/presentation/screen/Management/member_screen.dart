import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../auth/databaseHelper.dart';

class MemberScreen extends StatefulWidget {

  @override
  _MemberScreenState createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  FirebaseAuth auth =FirebaseAuth.instance;
  List<String> data =[];
  String? groupName;

  void searchMemberInGroup()async
  {
    final snapshot = await FirebaseDatabase.instance.ref().child('groups').child(groupName!).child('groupMembers').get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic>? values =
      snapshot.value as Map<dynamic, dynamic>?;
      if (values != null) {
        setState(() {
          data = values.values.map((e) => e.toString()).toList();
        });
      }
    } else {
      setState(() {
        data = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data found!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    searchMemberInGroup();
  }



  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Member List',style: textTheme.headlineMedium,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Container(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                        child: ListTile(
                          title: Text(data[index],style: textTheme.headlineSmall),
                          leading: CircleAvatar(
                            child: Text(data[index][0],style: textTheme.headlineSmall),
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
