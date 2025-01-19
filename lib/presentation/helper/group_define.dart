class Group {
  final String groupsId;
  final String groupsName;
  final String adminName;
  final String adminEmail;
  final int mealRate;
  final int balance;
  final List<String> members;
  final List<String> memberName;
  final List<String> bazarName;
  final List<int> bazarPrice;
  final List<int> lunchMeal;
  final List<int> dinnerMeal;
  final List<int> breakFirst;
  final List<int> totalDayMeal;
  final List<int> totalMonthlyMeal;


  Group(
      {required this.groupsId,
        required this.groupsName,
        required this.mealRate,
        required this.balance,
        required this.adminName,
        required this.adminEmail,
        required this.members,
        required this.memberName,
        required this.bazarName,
        required this.bazarPrice,
        required this.lunchMeal,
        required this.dinnerMeal,
        required this.breakFirst,
        required this.totalDayMeal,
        required this.totalMonthlyMeal,
      });

  factory Group.fromFirestore(Map<String, dynamic> json) =>
      Group(
        groupsId: json['groupsId'],
        groupsName: json['groupName'],
        adminName: json['adminName'],
        mealRate: json['mealRate'],
        balance: json['balance'],
        adminEmail: json['adminEmail'],
        members: List<String>.from(json['members']),
        memberName: List<String>.from(json['memberName']),
        bazarName: List<String>.from(json['bazarName']),
        bazarPrice: List<int>.from(json['bazarPrice']),
        lunchMeal: List<int>.from(json['lunchMeal']),
        dinnerMeal: List<int>.from(json['dinnerMeal']),
        breakFirst: List<int>.from(json['breakFirst']),
        totalDayMeal: List<int>.from(json['totalDayMeal']),
        totalMonthlyMeal: List<int>.from(json['totalMonthlyMeal']),
      );

  Map<String, dynamic> toFirestore() =>
      {
        'groupsId': groupsId,
        'groupName': groupsName,
        'adminName': adminName,
        'mealRate': mealRate,
        'balance': balance,
        'adminEmail': adminEmail,
        'members': members,
        'memberName': memberName,
        'bazarName': bazarName,
        'bazarPrice': bazarPrice,
        'lunchMeal': lunchMeal,
        'dinnerMeal': dinnerMeal,
        'breakFirst': breakFirst,
        'totalDayMeal': totalDayMeal,
        'totalMonthlyMeal': totalMonthlyMeal,

      };
}

