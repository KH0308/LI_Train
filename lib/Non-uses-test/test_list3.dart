// ignore_for_file: unnecessary_null_comparison
import 'package:fluttertoast/fluttertoast.dart';
// import 'connection_class.dart';
import 'package:flutter/material.dart';
import 'package:li_train/Non-uses-test/login.dart';
import 'package:li_train/Non-uses-test/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:li_train/Non-uses-test/test_list.dart';
import 'package:li_train/Non-uses-test/test_list2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestList3Widget extends StatefulWidget {
  const TestList3Widget({Key? key}) : super(key: key);

  @override
  State<TestList3Widget> createState() => _TestList3Widget();
}

class _TestList3Widget extends State<TestList3Widget> {
  String? stringResponse;
  late Map mapResponse;
  Map? dataResponse;
  List? listResponse;

  // Future singleApicall() async {
  //   http.Response response;
  //   response = await http.get(Uri.parse("https://reqres.in/api/users/2"));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // stringResponse = response.body;
  //       mapResponse = json.decode(response.body);
  //       dataResponse = mapResponse['data'];
  //     });
  //   }
  // }

  Future listApicall() async {
    http.Response response;
    response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));

    if (response.statusCode == 200) {
      setState(() {
        // stringResponse = response.body;
        mapResponse = json.decode(response.body);
        listResponse = mapResponse['data'];
      });
    }
  }

  @override
  void initState() {
    listApicall();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent navigation back from the registration page.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Test List"),
          automaticallyImplyLeading:
              false, // Disable the back button in the app bar
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Image.network(listResponse![index]['avatar']),
                  Text(listResponse![index]['first_name'].toString())
                ],
              ),
            );
          },
          itemCount: listResponse == null ? 0 : listResponse!.length,
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
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("user_email");
                  pref.remove("user_password");
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginWidget()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
