import 'package:bachelor_meal_asistance/presentation/helper/GroupService.dart';
import 'package:bachelor_meal_asistance/presentation/screen/Management/addMember.dart';
import 'package:bachelor_meal_asistance/presentation/screen/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import '../../uitils/Theme/theme.dart';
import '../login_screen.dart';

class Adminscreen extends StatefulWidget {
  final String email;
  final String groupsName;

  const Adminscreen({
    super.key,
    required this.email,
    required this.groupsName,
  });

  @override
  State<Adminscreen> createState() => _AdminscreenState();
}

class _AdminscreenState extends State<Adminscreen> {
  final GroupService _groupService = GroupService();
  int totalDayMeal = 0;
  Map<String, int> dayMeal = {
    "Breakfast": 0,
    "Lunch": 0,
    "Dinner": 0,
  };

  final TextEditingController breakfastController = TextEditingController();
  final TextEditingController lunchController = TextEditingController();
  final TextEditingController dinnerController = TextEditingController();
  final AuthService auth = AuthService();

  String? groupName = '';



  void updateDayMeal() {
    if (isValidInput(breakfastController.text) && canAddMeal("Breakfast")) {
      dayMeal["Breakfast"] = int.parse(breakfastController.text);
    }
    if (isValidInput(lunchController.text) && canAddMeal("Lunch")) {
      dayMeal["Lunch"] = int.parse(lunchController.text);
    }
    if (isValidInput(dinnerController.text) && canAddMeal("Dinner")) {
      dayMeal["Dinner"] = int.parse(dinnerController.text);
    }
    calculateTotal();
    clearControllers();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal values updated successfully!')),
    );
  }


  void calculateTotal() {
    setState(() {
      totalDayMeal = dayMeal.values.reduce((a, b) => a + b);
    });
  }

  void clearControllers() {
    breakfastController.clear();
    lunchController.clear();
    dinnerController.clear();
  }

  void deleteMeal(String mealKey) {
    setState(() {
      dayMeal[mealKey] = 0;
      calculateTotal();
    });
  }

  bool canAddMeal(String meal) {
    final now = DateTime.now();
    if (meal == "Breakfast" || meal == "Lunch") {
      // Breakfast ar Lunch er input shomoy hobe 6 PM theke 12 AM porjonto
      return now.hour >= 18 || now.hour < 6;
    } else if (meal == "Dinner") {
      // Dinner er input shomoy hobe 6 AM theke 6 PM porjonto
      return now.hour >= 6 && now.hour < 18;
    }
    return false;
  }

  bool isValidInput(String input) {
    return int.tryParse(input) != null && input.isNotEmpty;
  }

  void gotoLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Pass an empty string or a valid group ID
    );
  }

  @override
  void initState() {
    super.initState();
    fetchGroupName(widget.groupsName); // Fetch the group name when the screen initializes
  }

  void fetchGroupName(String groupId) async {

  }
  void Blance(String groupId) async {
  }
  void _fetchBazarPrices(String groupId) async {

  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return MaterialApp(
      theme: AppTheme.lighttheme,
      darkTheme: AppTheme.darktheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Group Name: $groupName')),
          backgroundColor: const Color(0xFF81C784),
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.person),
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: Colors.blue),
                child: const Text(
                  'User Profile',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.group),
                title: const Text('Member List'),
                onTap: () {
                  String currentUserId = 'actualUserId'; // Replace with your logic to get the actual user ID
                  String currentUserEmail = 'actualUserEmail'; // Replace with your logic to get the actual email
                  String currentUserName = 'actualUserName';
                  String currentgroupId = 'actualUserId';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMember(
                        currentUserId: currentUserId,
                        currentUserEmail: currentUserEmail,
                        currentUserName: currentUserName,
                        currentgroupId: currentgroupId,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: Text('Logout', style: theme.headlineSmall),
                onTap: () async {
                  await auth.signOut(context);
                  gotoLogin(context);
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildMealInputField("Breakfast", breakfastController, canAddMeal("Breakfast")),
                const SizedBox(height: 20),
                buildMealInputField("Lunch", lunchController, canAddMeal("Lunch")),
                const SizedBox(height: 20),
                buildMealInputField("Dinner", dinnerController, canAddMeal("Dinner")),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: updateDayMeal,
                  child: const Text("Add Meal Values"),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Today's Total Meal: ", style: theme.titleLarge),
                    Text(totalDayMeal.toString(), style: theme.titleLarge),
                  ],
                ),
                const SizedBox(height: 20),
                buildMealSummary(),
                const SizedBox(height: 20),
                buildBalanceSection(theme),
                const SizedBox(height: 20),
                buildCalendarSection(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMealInputField(String mealType, TextEditingController controller, bool isEnabled) {
    return TextFormField(
      enabled: isEnabled,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Enter $mealType Value"),
    );
  }

  Widget buildMealSummary() {
    return Column(
      children: [
        buildMealRow("Breakfast", dayMeal["Breakfast"]!),
        buildMealRow("Lunch", dayMeal["Lunch"]!),
        buildMealRow("Dinner", dayMeal["Dinner"]!),
      ],
    );
  }

  Row buildMealRow(String mealType, int value) {
    final theme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("$mealType: ", style: theme.titleLarge),
        Text(value.toString(), style: theme.titleLarge),
        TextButton(
          onPressed: () => deleteMeal(mealType),
          child: const Icon(Icons.delete),
        ),
      ],
    );
  }

  Container buildBalanceSection(TextTheme theme) {
    return Container(
      color: const Color(0xFF81C784),
      height: 200,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Balance: $Blance', style: theme.headlineMedium),
      ),
    );
  }

  Row buildCalendarSection(TextTheme theme) {
    return Row(
      children: [
        Container(
          width: 100,
          color: Colors.red,
          child: Center(child: Text('Fixed')),
        ),
        Expanded(
          child: IconButton(icon: Icon(Icons.input),
            onPressed: () {}

          ),
        ),
      ],
    );
  }
}
