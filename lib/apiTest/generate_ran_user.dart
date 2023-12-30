import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:li_train/apiTest/boring_activity.dart';
import 'package:li_train/apiTest/crud_user.dart';
import 'package:li_train/apiTest/gender_guess.dart';
import 'package:li_train/apiTest/home_api.dart';
import 'package:li_train/apiTest/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GRUWidget extends StatefulWidget {
  final String fName, lName, imgLink;
  const GRUWidget(
      {Key? key,
      required this.fName,
      required this.lName,
      required this.imgLink})
      : super(key: key);

  @override
  State<GRUWidget> createState() => _GRUWidgetState();
}

class _GRUWidgetState extends State<GRUWidget> {
  late Map mapResponse;
  late Map dataResponse;
  late String gender;
  String? genderStg, nameF, nameL, dtBirth, ageStg;
  String picURL =
      'https://www.energyfit.com.mk/wp-content/plugins/ap_background/images/default/default_large.png';
  late Map<String, dynamic> name;
  late Map<String, dynamic> dob;
  late Map<String, dynamic> pic;

  @override
  void initState() {
    genRanUsr();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future genRanUsr() async {
    http.Response response;
    response = await http.get(Uri.parse('https://randomuser.me/api/'));

    if (response.statusCode == 200) {
      setState(() {
        mapResponse = json.decode(response.body);
        // Access the "results" array from the response
        List<dynamic> results = mapResponse['results'];
        if (results.isNotEmpty) {
          // Extract "gender" from the first result
          gender = results[0]['gender'];
          genderStg = gender.toString();
          // Extract "name" from the first result
          name = results[0]['name'];
          nameF = name['first'].toString();
          nameL = name['last'].toString();
          // Extract "dob" from the first result
          dob = results[0]['dob'];
          dtBirth = dob['date'].toString();
          ageStg = dob['age'].toString();
          // Extract "Picture" from first result
          pic = results[0]['picture'];
          picURL = pic['medium'].toString();

          // Print the extracted data as needed
          print('Gender: $gender');
          print('Name: ${name['first']} ${name['last']}');
          print('Date of Birth: ${dob['date']}');
          print('Age: ${dob['age']}');
          print('Picture: ${pic['medium']}');

          // You can also store these values in your dataResponse map
          // dataResponse = {
          //   'gender': gender,
          //   'name': name,
          //   'dob': dob,
          // };
        }
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    picURL,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Name: $nameF $nameL'),
                Text('Date of Birth: $dtBirth'),
                Text('Gender: $genderStg'),
                Text('Age: $ageStg'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    genRanUsr();
                  },
                  child: const Text('Generate Another Random User'),
                ),
              ],
            ),
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
