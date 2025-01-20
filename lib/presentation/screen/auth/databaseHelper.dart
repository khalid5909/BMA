import 'package:bachelor_meal_asistance/presentation/screen/Management/Profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DatabaseHelper {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase rtDB = FirebaseDatabase.instance;
  DateTime time= DateTime.now();
  List <String> groupName = [];
  String? value = 'Value is Empty';
  String? phoneNumber;

  double? balanceNo;




  Future<Map<String, dynamic>?> getBreakfast() async {
    final DatabaseReference databaseReference = rtDB
        .ref()
        .child('user')
        .child(auth.currentUser!.uid)
        .child('breakFirst');

    try {
      // Fetch the data from the database
      final DataSnapshot snapshot = await databaseReference.get();

      if (snapshot.exists) {
        // Return the last value from the "breakFirst" node
        final data = snapshot.value as Map<String, dynamic>;
        return data.values.last as Map<String, dynamic>;
      } else {
        print("No breakfast data found.");
        return null ;
      }
    } catch (e) {
      print("Error fetching breakfast data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLunch() async {
    final DatabaseReference databaseReference = rtDB
        .ref()
        .child('user')
        .child(auth.currentUser!.uid)
        .child('lunch');

    try {
      // Fetch the data from the database
      final DataSnapshot snapshot = await databaseReference.get();

      if (snapshot.exists) {
        // Return the last value from the "breakFirst" node
        final data = snapshot.value as Map<String, dynamic>;
        return data.values.last as Map<String, dynamic>;
      } else {
        print("No breakfast data found.");
        return null ;
      }
    } catch (e) {
      print("Error fetching breakfast data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDinner() async {
    final DatabaseReference databaseReference = rtDB
        .ref()
        .child('user')
        .child(auth.currentUser!.uid)
        .child('breakFirst');

    try {
      final DataSnapshot snapshot = await databaseReference.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<String, dynamic>;
        return data.values.last as Map<String, dynamic>;
      } else {
        print("No breakfast data found.");
        return null ;
      }
    } catch (e) {
      print("Error fetching breakfast data: $e");
      return null;
    }
  }



  Future createGroup(
      {required String groupName, required String adminEmail, required memberEmail}) async
  {
    try {
      DatabaseReference groupRef = FirebaseDatabase.instance.ref().child(
          'groups').child(groupName);
      Map<String, dynamic> groupData = {
        'createdAt': DateTime.now().toIso8601String(),
        'blockStatus': "no",
        'groupName': groupName,
        'adminName': adminEmail,
        'membersList': [value],
        'breakFast':[value],
        'lunch':[value],
        'dinner':[value],
        'bazarItem':[value],
        'bazarPrice':[value],
        'memberBalance':[value],
      };
      await groupRef.set(groupData);
      return;
    } catch (e) {
      throw Exception("Failed to create group");
    }
  }

  Future<void> addMemberToGroup({
    required String groupName,
    required String newMemberEmail,
  }) async {
    try {

      DatabaseReference memberListRef = FirebaseDatabase.instance
          .ref()
          .child('groups')
          .child(groupName)
          .child('membersList');
      DatabaseEvent event = await memberListRef.once();

      if (event.snapshot.exists && event.snapshot.value != null) {
        List<dynamic> currentData = List.from(event.snapshot.value as List);
        if (!currentData.contains(newMemberEmail)) {
          currentData.add(newMemberEmail);
          await memberListRef.set(currentData);
          print("Member added successfully!");
        } else {
          print("Member already exists in the group!");
        }
      } else {
        await memberListRef.set([newMemberEmail]);
        print("New member list created with the added member!");
      }
    } catch (e) {
      print("Failed to add member: $e");
      throw Exception("Failed to add member to the group");
    }
  }

  Future updateGroupName({required String groupName})async
  {
    DatabaseReference databaseReference = rtDB.ref().child('user').child(auth.currentUser!.uid);
    databaseReference.push().update({'groups': [groupName]});
  }






  Future joinGroup({required String groupName, required String memberEmail}) async
  {
    try {
      DatabaseReference groupRef = FirebaseDatabase.instance.ref("groups")
          .child(groupName);
      DatabaseEvent groupEvent = await groupRef.once();

      if (groupEvent.snapshot.value != null) {
        Map<dynamic, dynamic> groupData = groupEvent.snapshot.value as Map;
        List<dynamic> members = List.from(groupData['members']);

        if (!members.contains(memberEmail)) {
          members.add(memberEmail);

          await groupRef.update({
            'members': members,
          });
        }
      }
    } catch (e) {
      throw Exception("Failed to create group"
      );
    }
  }

  Future<void> addMember(String userEmail, String groupName) async {
    DatabaseReference groupRef = FirebaseDatabase.instance.ref()
        .child('groups')
        .child(groupName)
        .child('membersList');

    try {
      final DatabaseEvent event = await groupRef.once();

      if (event.snapshot.exists) {
        List<dynamic> members = List.from(event.snapshot.value as List<dynamic>);

        if (!members.contains(userEmail)) {
          members.add(userEmail);

          await groupRef.set(members);
        }
      } else {
        // If no members exist, create a new list
        await groupRef.set([userEmail]);
      }
    } catch (e) {
      throw Exception("Failed to add member: $e");
    }
  }




  Future<List<String>> groupMemberList(String groupName) async {
    try {
      DatabaseReference groupRef = FirebaseDatabase.instance.ref()
          .child('groups')
          .child(groupName);

      final DatabaseEvent event = await groupRef.child('membersList').once();

      if (event.snapshot.exists) {
        return List<String>.from(event.snapshot.value as List<dynamic>);
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching members list: $e");
      }
      return [];
    }
  }

  Future createProfile() async {
    try {
      final User?  singUpUser = (await auth.currentUser!.uid) as User?;
      if (singUpUser != null) {
        DatabaseReference userRef = rtDB.ref().child('user').child(singUpUser as String);
        await userRef.update({
          'breakfast': [],
          'lunch':[],
          'dinner':[],
        });
      }
      return singUpUser;
    } catch (e)
    {
      print("Error during sign-up: $e");
    }
  }


  Future<void> addBreakfastMeal({required String meal})async
  {
    DatabaseReference groupRef = FirebaseDatabase.instance.ref().child(
        'user').child(auth.currentUser!.uid).child('groups');
    groupRef.onValue.listen((DatabaseEvent event){
      final List<dynamic>? data =  event.snapshot.value as List<String>?;
      if (data!=null){
         groupName = List<String>.from(data);
      }
    });
    DatabaseReference databaseReference = rtDB.ref().child('groups').child(groupName as String ).child('breakFast');
    databaseReference.push().set({
      'time': time,
      'meal': meal,
    });

  }

  Future addLunchMeal({required String meal})async
  {
    DatabaseReference groupRef = FirebaseDatabase.instance.ref().child(
        'user').child(auth.currentUser!.uid).child('groups');
    groupRef.onValue.listen((DatabaseEvent event){
      final List<dynamic>? data =  event.snapshot.value as List<String>?;
      if (data!=null){
        groupName = List<String>.from(data);
      }
    });
    DatabaseReference databaseReference = rtDB.ref().child('groups').child(groupName as String ).child('lunch');
    databaseReference.push().set({
      'time': time,
      'meal': meal,
    });
  }

  Future addDinnerMeal({required String meal})async
  {
    DatabaseReference groupRef = FirebaseDatabase.instance.ref().child(
        'user').child(auth.currentUser!.uid).child('groups');
    groupRef.onValue.listen((DatabaseEvent event){
      final List<dynamic>? data =  event.snapshot.value as List<String>?;
      if (data!=null){
        groupName = List<String>.from(data);
      }
    });
    DatabaseReference databaseReference = rtDB.ref().child('groups').child(groupName as String ).child('dinner');
    databaseReference.push().set({
      'time': time,
      'meal': meal,
    });
  }

  Future<void> getUserGroups() async {
    DatabaseReference userGroupsRef = FirebaseDatabase.instance
        .ref()
        .child('user')
        .child(auth.currentUser!.uid)
        .child('groups');
    userGroupsRef.onValue.listen((DatabaseEvent event){
      if (event.snapshot.exists) {
         event.snapshot.value as String;
        print("User  is part of the following groups:");
      } else {
      print("User  is not part of any group.");
      }
    });
  }


  Future<void> checkMemberAndRedirect(
      {required String currentUserEmail,required BuildContext context})async
  {
    try {
      DatabaseReference groupRef = FirebaseDatabase.instance.ref()
          .child('groups');
      final DatabaseEvent event = await groupRef.once();

      if (event.snapshot.exists)
      {
        final Map<dynamic, dynamic> membersList =
        event.snapshot.value as Map<dynamic, dynamic>;
        if (membersList.containsValue(currentUserEmail))
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (
                context) => const ProfileScreen()), // Ensure Signup is imported
          );
        }
      }
      else
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder:
              (context) => const ProfileScreen(),
          ),
        );
      }
    } catch (e) {
    // Handle any errors
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    content: Text("Error: $e"),
    ),
    );
    }

  }

}



class UserDatabase {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase rlDB = FirebaseDatabase.instance;


  Future searchUserByEmail ({required String email})async
  {
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('user');
    final DataSnapshot snapshot = await usersRef.get();
    if (snapshot.exists){
      Map<String,dynamic> allUsers = snapshot.value as Map<String,dynamic>;
      for (var email in allUsers.keys){
        final user = allUsers[email] as Map<String,dynamic>;
        if(user['email'] == email){
          return user;
        }
      }
    }
  }


}






