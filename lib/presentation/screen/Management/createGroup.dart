import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../auth/databaseHelper.dart';
import 'groupDashboard_screan.dart';
import 'bottomNavBarForDasboard.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final DatabaseHelper database = DatabaseHelper();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController groupName = TextEditingController();
  final TextEditingController email = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  Future<void> createGroup() async {
    if (groupName.text.trim().isEmpty || email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group name and email are required!")),
      );
      return;
    }

    try {
      await database.createGroup(
        groupName: groupName.text.trim(),
        adminEmail: auth.currentUser?.email ?? '',
        memberEmail: email.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Group created successfully!")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BotNavBarForDas()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create group: $e")),
      );
    }
  }

  Future<void> searchEmail(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final snapshot =
      await FirebaseDatabase.instance.ref().child('user').get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        final filteredResults = data.entries
            .where((entry) {
          final user = entry.value as Map<dynamic, dynamic>;
          return user['email']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        })
            .map((entry) {
          final user = entry.value as Map<dynamic, dynamic>;
          return {
            'email': user['email'] ?? 'No Email',
            'name': user['name'] ?? 'No Name',
          };
        })
            .toList();

        setState(() {
          searchResults = List<Map<String, dynamic>>.from(filteredResults);
        });
      } else {
        setState(() {
          searchResults = [];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching emails: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: groupName,
              decoration: const InputDecoration(
                labelText: 'Add Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              onChanged: searchEmail,
              controller: email,
              decoration: InputDecoration(
                labelText: 'User Email',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => searchEmail(email.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroup,
              child: const Text('Create Group'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(result['name']),
                      subtitle: Text(result['email']),
                      onTap: (){
                        setState(() {
                          email.text = result['email'];
                        });
                      },
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
