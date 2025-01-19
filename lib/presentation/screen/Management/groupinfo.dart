import 'package:flutter/material.dart';

class Groupinfo extends StatefulWidget {
  const Groupinfo({super.key});

  @override
  State<Groupinfo> createState() => _GroupinfoState();
}

class _GroupinfoState extends State<Groupinfo> {
  final List<Map<String, dynamic>> items = [
    {"name": "Rice", "price": 50, "meal": 3},
    {"name": "Chicken", "price": 120, "meal": 2},
    {"name": "Vegetables", "price": 30, "meal": 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Food List")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          
          final item = items[index];
          return Card(
            child: ListTile(
              title: Text(item['name']), // নাম দেখাবে
              subtitle: Text("Meal: ${item['meal']}"), // মিল দেখাবে
              trailing: Text("৳${item['price']}"), // দাম দেখাবে
            ),
          );
        },
      ),
    );
  }
}
