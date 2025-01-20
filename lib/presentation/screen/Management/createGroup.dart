import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth_screen.dart';
import '../auth/databaseHelper.dart';
import 'Profile_screen.dart';


class CreateGroup extends StatefulWidget {

  const CreateGroup({super.key,});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  DatabaseHelper database = DatabaseHelper();
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthService authService = AuthService();

  final TextEditingController groupName = TextEditingController();
  final TextEditingController email = TextEditingController();

  Future<void> createGroup() async {
    if (groupName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Group name cannot be empty")),
      );
      return;
    }
    if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Add at least one member")),
      );
      return;
    }
    final String? adminEmail = FirebaseAuth.instance.currentUser?.email;
    if (adminEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Admin email not found. Please log in again.")),
      );
      return;
    }
    try {
      await database.createGroup(
        groupName: groupName.text.trim(),
        adminEmail: auth.currentUser?.email as String,
        memberEmail: email.text.trim(),
      );
      await database.updateGroupName(groupName: groupName.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Group created successfully!")),
      );
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfileScreen()));
    } catch (e) {
      print("Error creating group: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create group")),
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: groupName,
              decoration: InputDecoration(
                labelText: 'Add Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: email,
              decoration: InputDecoration(
                labelText: 'Member Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroup,
              child: Text('Create Group'),
            ),
          ],
        ),
      ),
    );
  }
}
