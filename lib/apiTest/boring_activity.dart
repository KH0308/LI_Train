import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:li_train/apiTest/crud_user.dart';
import 'package:li_train/apiTest/gender_guess.dart';
import 'package:li_train/apiTest/generate_ran_user.dart';
import 'package:li_train/apiTest/home_api.dart';
import 'package:li_train/apiTest/login_api.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BoringWidget extends StatefulWidget {
  final String fName, lName, imgLink;
  const BoringWidget(
      {Key? key,
      required this.fName,
      required this.lName,
      required this.imgLink})
      : super(key: key);

  @override
  State<BoringWidget> createState() => _BoringWidgetState();
}

class _BoringWidgetState extends State<BoringWidget> {
  late Map mapResponse;
  String activity = "";
  String type = "";
  String participants = "";
  String price = "";
  String link = "";
  String key = "";
  String accessibility = "";

  @override
  void initState() {
    genRandActv();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future genRandActv() async {
    http.Response response;
    response =
        await http.get(Uri.parse('https://www.boredapi.com/api/activity'));

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        // Access the "results" array from the response
        activity = mapResponse['activity'].toString();
        type = mapResponse['type'].toString();
        participants = mapResponse['participants'].toString();
        price = mapResponse['price'].toString();
        link = mapResponse['link'].toString();
        key = mapResponse['key'].toString();
        accessibility = mapResponse['accessibility'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        appBar:
            AppBar(title: const Text("Home"), automaticallyImplyLeading: false,
            leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  // Open the drawer when the menu icon is tapped
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Are you boring? Let's Do Thisss",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Activity: $activity",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Type: $type",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Participants: $participants",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Price: $price",
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Accessibility: $accessibility",
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                        "Don't find it interesting? Click below to find another fun"),
                    ElevatedButton(
                      onPressed: () {
                        genRandActv();
                      },
                      child: const Text("Click Me"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          elevation: 16,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 5, 10),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          width: 130,
                          height: 130,
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            widget.imgLink,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(widget.fName),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(widget.lName),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                // selected: selectedIndex == 1,
                onTap: () async {
                  // show message
                  Fluttertoast.showToast(
                    msg: "Home Page",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Then close the drawer
                  Navigator.pop(context);
                  // reload/back page home
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HomeApiWidget()));
                },
              ),
              ListTile(
                title: const Text('Generated Random User'),
                // selected: selectedIndex == 2,
                onTap: () {
                  // show message
                  Fluttertoast.showToast(
                    msg: "GRU Page",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Then close the drawer
                  Navigator.pop(context);
                  // navigate to page
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GRUWidget(
                          fName: widget.fName,
                          lName: widget.lName,
                          imgLink: widget.imgLink)));
                },
              ),
              ListTile(
                title: const Text('Are You Bored'),
                // selected: selectedIndex == 2,
                onTap: () {
                  // show msg
                  Fluttertoast.showToast(
                    msg: "Boring Page",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BoringWidget(
                          fName: widget.fName,
                          lName: widget.lName,
                          imgLink: widget.imgLink)));
                },
              ),
              ListTile(
                title: const Text('Gender Guess by Name'),
                // selected: selectedIndex == 2,
                onTap: () {
                  // show msg
                  Fluttertoast.showToast(
                    msg: "GG Page",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GenderGuestWidget(
                          fName: widget.fName,
                          lName: widget.lName,
                          imgLink: widget.imgLink)));
                },
              ),
              ListTile(
                title: const Text('CRUD User'),
                // selected: selectedIndex == 2,
                onTap: () {
                  // show msg
                  Fluttertoast.showToast(
                    msg: "CRUD Page",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  // Then close the drawer
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CRUDUserWidget(
                          fName: widget.fName,
                          lName: widget.lName,
                          imgLink: widget.imgLink)));
                },
              ),
              ListTile(
                title: const Text('Log Out'),
                // selected: selectedIndex == 3,
                onTap: () async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.remove("user_email");
                  pref.remove("user_password");
                  // show msg
                  Fluttertoast.showToast(
                    msg: "Success logout",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginApiWidget()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
