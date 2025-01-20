import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../home_screen.dart';

class JoinGroupPage extends StatefulWidget {


   JoinGroupPage({Key? key}) : super(key: key);

  @override
  _JoinGroupPageState createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final  String? firebaseAuth= FirebaseAuth.instance.currentUser?.email;
  final TextEditingController searchController = TextEditingController();
  List<String> searchResults = [];
  bool isLoading = false;


  void searchGroupByName({required String groupName}) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      DatabaseReference groupRef = FirebaseDatabase.instance.ref().child("groups");

      DatabaseEvent searchGroup = await groupRef.once();

      if (searchGroup.snapshot.value != null) {
        setState(() {
          searchResults = searchGroup as List<String>;
        });
      } else {
        setState(() {
          searchResults = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Group not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  void joinGroup(String currentEmail) async {
    if(searchController.text.isEmpty)
    {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter you Group Name")));
      return;
    }
    try{
      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.joinGroup(groupName: searchController.text.trim(), memberEmail: currentEmail);
    }catch(e)
    {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Join Group')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search Group by Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => searchGroupByName,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => joinGroup,
              child: const Text('Join Group'),
            ),
            const SizedBox(height: 10),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (searchResults.isEmpty)
              const Text('No results found.'),
            if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context,int index) {
                    return Card(
                      child: ListTile(
                        title: Text(searchResults[index],style: textTheme.headlineSmall),
                        leading: CircleAvatar(
                          child: Text(searchResults[index][0],style: textTheme.headlineSmall),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
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
