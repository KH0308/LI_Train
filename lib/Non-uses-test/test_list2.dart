// ignore_for_file: unnecessary_null_comparison
import 'package:fluttertoast/fluttertoast.dart';
// import 'connection_class.dart';
import 'package:flutter/material.dart';
import 'package:li_train/Non-uses-test/login.dart';
import 'package:li_train/Non-uses-test/home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:li_train/Non-uses-test/test_list.dart';
import 'package:li_train/Non-uses-test/test_list3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestListWidget extends StatefulWidget {
  const TestListWidget({Key? key}) : super(key: key);

  @override
  State<TestListWidget> createState() => _TestListWidget();
}

class _TestListWidget extends State<TestListWidget> {
  String? stringResponse;
  late Map mapResponse;
  Map? dataResponse;
  List? listResponse;
  TextEditingController edtNameController = TextEditingController();

  Future singleApicall() async {
    http.Response response;
    response = await http.get(Uri.parse("https://reqres.in/api/users/2"));

    if (response.statusCode == 200) {
      setState(() {
        // stringResponse = response.body;
        mapResponse = json.decode(response.body);
        dataResponse = mapResponse['data'];
      });
    }
  }

  Future viewUpdtcall() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));

    if (response.statusCode == 200) {
      setState(() {
        // stringResponse = response.body;
        mapResponse = json.decode(response.body);
        stringResponse = mapResponse['title'];
      });
    }
  }

  // try update data using json trough api
  Future updateData(String fName) async {
    final http.Response response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': fName,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update Success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TestListWidget()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Cannot Update",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Future listApicall() async {
  //   http.Response response;
  //   response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       // stringResponse = response.body;
  //       mapResponse = json.decode(response.body);
  //       listResponse = mapResponse['data'];
  //     });
  //   }
  // }

  @override
  void initState() {
    singleApicall();
    // listApicall();
    viewUpdtcall();
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueAccent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Single Data",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                        height: 10), // Add some spacing below the title
                    dataResponse == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Data is being loaded"),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(dataResponse!['first_name'].toString()),
                              Text(dataResponse!['last_name'].toString()),
                              Text(stringResponse.toString()),
                            ],
                          ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    TextField(
                      controller: edtNameController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your name'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String updtName = edtNameController.text;

                        if (updtName != null) {
                          updateData(updtName);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please insert the update name",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                      child: const Text(
                        "Udate Name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
