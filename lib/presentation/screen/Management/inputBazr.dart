import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../uitils/Theme/theme.dart';

class Input_Bazar extends StatefulWidget {
  const Input_Bazar({super.key});

  @override
  State<Input_Bazar> createState() => _Input_BazarState();
}

class _Input_BazarState extends State<Input_Bazar> {
  final List<String> items = List<String>.generate(20, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.darktheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Input Bazar'),
          backgroundColor: const Color(0xFF81C784),
        ),
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  //buildMealInputField("Item"),
                  const SizedBox(height: 20),
                  //buildMealInputField('Price'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(itemCount: items.length,
              itemBuilder: (context,index){
                return ListTile(
                  title: Text(items[index]),
                );
              },)
            )
          ],
        ),
      ),
    );
  }

  Widget buildMealInputField(
      String mealType, TextEditingController controller, bool isEnabled) {
    return TextFormField(
      enabled: isEnabled,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: ''),
    );
  }
}
