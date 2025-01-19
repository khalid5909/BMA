
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'group_define.dart';

class GroupService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController groupName = TextEditingController();
  TextEditingController crewEmail = TextEditingController();

  // Consolidate meal addition methods into one
  Future<void> addMeal(String groupName, String crewEmail, String mealType, int mealValue) async {
    try {
      await _firestore.collection(groupName).doc(crewEmail).set({
        mealType: mealValue,
      }, SetOptions(merge: true)); // Merges meal values if they already exist
    } catch (e) {
      print('Error adding $mealType: $e');
    }
  }

  // Create group
  Future<void> createGroup(String groupName, String crewEmail,currentEmail) async {

    try {
      Map<String,dynamic> data ={
        'breakfast':[],
        'lunch':[],
        'dinner':[],
        'Bazar':[],
        'bazar price':[],
      };
      String docId = '${currentEmail}_${crewEmail}';
      //await _firestore.collection(groupName).doc(docID).set(data);
    } catch (e) {
      print('Error creating group: $e');
    }
  }

  // Search for a group by name
  Future<List<Group>> searchGroupByName(String groupName) async {
    try {
      final querySnapshot = await _firestore
          .collection('groups')
          .where('groupName', isEqualTo: groupName)
          .get();
      return querySnapshot.docs
          .map((doc) => Group.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      print('Error searching for group: $e');
      return [];
    }
  }
}
