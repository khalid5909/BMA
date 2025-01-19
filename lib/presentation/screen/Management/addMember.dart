import 'package:flutter/material.dart';
import '../../helper/GroupService.dart';

class AddMember extends StatefulWidget {
  final String currentUserId;
  final String currentUserEmail;
  final String currentUserName;
  final String currentgroupId;

  const AddMember({
    Key? key,
    required this.currentUserId,
    required this.currentUserEmail,
    required this.currentUserName,
    required this.currentgroupId,
  }) : super(key: key);

  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  final GroupService _groupService = GroupService();

  List<Map<String, dynamic>> members = []; // Type-specified list for better usage
  String email = '';
  int balance = 0;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching members: $e')),
      );
    }
  }



  Future<void> Balance(String email, int value) async {
    if (value > 0) {
      try {

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating balance: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount to add balance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Member'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter Member Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: (){},
              child: const Text('Add Member'),
            ),
            SizedBox(height: 20),
            Text(
              'Members in Group',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index,) {
                  final member = members[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text((index + 1).toString()),
                      ),
                      title: Text(member['email']),
                      subtitle: Text('Balance: $Balance}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
