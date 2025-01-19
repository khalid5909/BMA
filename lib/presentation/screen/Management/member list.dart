import 'package:bachelor_meal_asistance/presentation/screen/auth/databaseHelper.dart';
import 'package:flutter/material.dart';


class MemberList extends StatefulWidget {

  final String groupName;

  const MemberList ({Key? key, required this.groupName}) : super (key: key);

  @override
  _MemberListState createState() => _MemberListState();
}

class _MemberListState extends State<MemberList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<String> membersList =[];

  Future <void> groupMemberList () async
  {
    List<String> members =
    await databaseHelper.groupMemberList(widget.groupName);
    setState(() {
      membersList = members;
    });
  }

  @override
  void initState() {
    super.initState();
    groupMemberList();
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: membersList.length,
          itemBuilder: (BuildContext context,int index)
          {
            return Card(
            child: ListTile(
              title: Text(membersList[index]),
            ),
            );
          }),
    );
  }
}
