import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:li_train/apiTest/boring_activity.dart';
import 'package:li_train/apiTest/crud_user.dart';
import 'package:li_train/apiTest/gender_guess.dart';
import 'package:li_train/apiTest/generate_ran_user.dart';
import 'package:li_train/apiTest/home_api.dart';
import 'package:li_train/apiTest/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileWidget extends StatefulWidget {
  final String uName, uEmail, imgLink;
  const ProfileWidget({Key? key, required this.uName, required this.uEmail, required this.imgLink}) : super(key: key);

  @override
  State<ProfileWidget> createState() => ProfileWidgetState();
}

class ProfileWidgetState extends State<ProfileWidget> {

  String? storeTkn;
  String email = "";
  String firstname = "";
  String icNumber = "";
  String gender = "";
  String birthdate = "";
  String phone = "";
  String bankAccName = "";
  String bankAccNum = "";

  @override
  void initState() {
    profileApicall();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future profileApicall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storeTkn = prefs.getString('user_token');
    http.Response response;
    response = await http.get(
      Uri.parse("https://staging.api.medkad.com/v1/profile"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $storeTkn',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        // stringResponse = response.body;
        email = data['email'].toString();
        firstname = data['firstname'].toString();
        icNumber = data['ic_number'].toString();
        gender = data['gender'].toString();
        birthdate = data['birthdate'].toString();
        phone = data['phone'].toString();
        bankAccName = data['bank_account_name'].toString();
        bankAccNum = data['bank_account_number'].toString();
      });
      print(response.body);
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {return false;},
      child: Scaffold(
        appBar:
            AppBar(title: const Text("Profile"), automaticallyImplyLeading: false,
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Create a function to build each profile field widget
              buildProfileField("Email", email),
              buildProfileField("First Name", firstname),
              buildProfileField("IC Number", icNumber),
              buildProfileField("Gender", gender),
              buildProfileField("Birthdate", birthdate),
              buildProfileField("Phone", phone),
              buildProfileField("Bank Account Name", bankAccName),
              buildProfileField("Bank Account Number", bankAccNum),
            ],
          ),
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
                        child: Text(widget.uName),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(widget.uEmail),
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
                          fName: widget.uName,
                          lName: widget.uEmail,
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
                          fName: widget.uName,
                          lName: widget.uEmail,
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
                          fName: widget.uName,
                          lName: widget.uEmail,
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
                          fName: widget.uName,
                          lName: widget.uEmail,
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

  Widget buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value.isNotEmpty ? value : 'N/A',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
