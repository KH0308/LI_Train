import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:li_train/Non-uses-test/login.dart';
import 'package:li_train/Non-uses-test/test_list.dart';
import 'package:li_train/Non-uses-test/test_list2.dart';
import 'package:li_train/Non-uses-test/test_list3.dart';
import 'connection_class.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String storedName = "";
  String? username;
  String? userpass;
  // int selectedIndex = 0;

  @override
  void initState() {
    _loadName();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     selectedIndex = index;
  //   });
  // }

  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('user_email');
    userpass = prefs.getString('user_password');

    if (username != null && userpass != null) {
      String? userid = username;
      var baseUrl = ConnectionClass.ipUrl;
      final userResponse = await http
          .get(Uri.parse('${baseUrl}getDataUser.php?emailID=$userid'));

      if (userResponse.statusCode == 200) {
        final userData = json.decode(userResponse.body);
        if (userData.isNotEmpty) {
          setState(() {
            storedName = userData[0]['name'];
          });
        }
      } else {
        throw Exception('Failed to fetch user data');
      }
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginWidget()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Home"), automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 250,
              height: 250,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Password: $storedName'),
                  Text('Password: $username'),
                  Text('Password: $userpass'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("user_email");
                pref.remove("user_password");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginWidget()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('LI Train'),
            ),
            ListTile(
              title: const Text('Home'),
              // selected: selectedIndex == 1,
              onTap: () async {
                // Update the state of the app
                // _onItemTapped(1);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const HomeWidget()));
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Test Single Data'),
              // selected: selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(2);
                Fluttertoast.showToast(
                  msg: "Test Single Data",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
                // Then close the drawer
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TestListWidget()));
              },
            ),
            ListTile(
              title: const Text('Test List'),
              // selected: selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(2);
                Fluttertoast.showToast(
                  msg: "Test List Page",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
                // Then close the drawer
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TestList3Widget()));
              },
            ),
            ListTile(
              title: const Text('Test Update'),
              // selected: selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                // _onItemTapped(2);
                Fluttertoast.showToast(
                  msg: "Test update data",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
                // Then close the drawer
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PostApi()));
              },
            ),
            ListTile(
              title: const Text('Log Out'),
              // selected: selectedIndex == 3,
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("user_email");
                pref.remove("user_password");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginWidget()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
