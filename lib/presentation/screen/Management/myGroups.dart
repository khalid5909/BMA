import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'bottomNavBarForDasboard.dart';

class MyGroups extends StatefulWidget {
  const MyGroups({super.key});

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  List<String> groupData = [];

  bool isLoading = true;

  Future<void> myGroupList() async {
    try {
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('user')
          .child(FirebaseAuth.instance.currentUser!.uid)
          .child('groups')
          .get();

      if (snapshot.exists) {
        final List<dynamic>? groups = snapshot.value as List<dynamic>?;

        if (groups != null) {
          setState(() {
            groupData = groups.cast<String>();  // Correctly cast dynamic to String
          });
        } else {
          setState(() {
            groupData = [];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No groups found!')),
          );
        }
      } else {
        setState(() {
          groupData = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No groups found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching groups: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    myGroupList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Groups')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : groupData.isEmpty
          ? const Center(child: Text('You are not part of any group.'))
          : ListView.builder(
        itemCount: groupData.length,
        itemBuilder: (context, index) {
          final String groupName = groupData[index];  // Directly access the group name
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('Group Name: $groupName'),
              subtitle: Text('Index: $index'),
              leading: CircleAvatar(child: Text('${index + 1}')),
              onTap: () {

                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => BotNavBarForDas()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Tapped on $groupName ',  // Use group directly here
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
