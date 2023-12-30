import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Example',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  String storedName = "";

  @override
  void initState() {
    super.initState();
    // Load the stored name from SharedPreferences when the app starts.
    _loadName();
  }

  // Function to save the user's name to SharedPreferences.
  _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', nameController.text);
    setState(() {
      storedName = nameController.text;
    });
  }

  // Function to load the user's name from SharedPreferences.
  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('user_name');
    if (name != null) {
      setState(() {
        storedName = name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SharedPreferences Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, $storedName',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _saveName,
                  child: Text('Save Name'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _loadName,
                  child: Text('Load Name'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
