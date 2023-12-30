import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:core';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:li_train/apiTest/boring_activity.dart';
import 'package:li_train/apiTest/gender_guess.dart';
import 'package:li_train/apiTest/generate_ran_user.dart';
import 'package:li_train/apiTest/home_api.dart';
import 'package:li_train/apiTest/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CRUDUserWidget extends StatefulWidget {
  final String fName, lName, imgLink;
  const CRUDUserWidget(
      {Key? key,
      required this.fName,
      required this.lName,
      required this.imgLink})
      : super(key: key);

  @override
  State<CRUDUserWidget> createState() => _CRUDUserWidgetState();
}

class _CRUDUserWidgetState extends State<CRUDUserWidget> {
  late List<Map<String, dynamic>> listResponse = [];

  String gender = 'male';
  String stsUpd = '';
  String gdrUpd = '';
  String idDel = '';
  String nmSearch = '';
  bool isSearching = false;

  // search name controller
  TextEditingController searchBarController = TextEditingController();

  // update exsiting user
  TextEditingController idUpdController = TextEditingController();
  TextEditingController emailUpdController = TextEditingController();
  TextEditingController nameUpdController = TextEditingController();
  // TextEditingController stsUpdController = TextEditingController();

  // add new user controller
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController statusController =
      TextEditingController(text: 'Active');

  // bearer token primary
  String bearerTkn = '06adeef9902ff9de14ebda74adcce09fe7073e06ce5d55e92688abae6170fdd4';

  @override
  void initState() {
    super.initState();
    listApiCall();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future create(String id, String name, String status, String gender) async {
    http.Response response;
    final requestData = {
      'email': id,
      'name': name,
      'gender': gender,
      'status': status,
    };

    response = await http.post(
      Uri.parse('https://gorest.co.in/public/v2/users'),
      headers: {
        'Content-Type': 'application/json;  charset=utf-8',
        'Authorization': 'Bearer $bearerTkn', // Include the bearer token in the headers
      },
      body: json.encode(requestData),
    );

    if (response.statusCode == 201) {
      Fluttertoast.showToast(
        msg: "Create Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      ).then((value) {
        Navigator.of(context).pop();
        emailController.clear();
        nameController.clear();
        gender = 'male';
        // Fetch the updated list after the toast is shown
        setState(() {
          listApiCall();
        });
      });
    } else {
      // Registration failed
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Create failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
      print('Response body: ${response.body}');
    }
  }

  Future update(String id, String email, String name, String status, String gender) async {
    http.Response response;
    final requestData = {
      'email': email,
      'name': name,
      'gender': gender,
      'status': status,
    };

    response = await http.put(
      Uri.parse('https://gorest.co.in/public/v2/users/$id'),
      headers: {
        'Content-Type': 'application/json;  charset=utf-8',
        'Authorization': 'Bearer $bearerTkn', // Include the bearer token in the headers
      },
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      ).then((value) {
        Navigator.of(context).pop();
        idUpdController.clear();
        emailUpdController.clear();
        nameUpdController.clear();
        gdrUpd = '';
        stsUpd = '';
        // Fetch the updated list after the toast is shown
        setState(() {
          listApiCall();
        });
      });
    } else {
      // Registration failed
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Update failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
      print('Response body: ${response.body}');
    }
  }

  Future delete(String id) async {
    http.Response response;
    // final requestData = {
    //   'email': email,
    //   'name': name,
    //   'gender': gender,
    //   'status': status,
    // };

    response = await http.delete(
      Uri.parse('https://gorest.co.in/public/v2/users/$id'),
      headers: {
        'Content-Type': 'application/json;  charset=utf-8',
        'Authorization': 'Bearer $bearerTkn', // Include the bearer token in the headers
      },
      // body: json.encode(requestData),
    );

    if (response.statusCode == 204) {
      Fluttertoast.showToast(
        msg: "Delete Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      ).then((value) {
        Navigator.of(context).pop();
        idDel = '';
        // Fetch the updated list after the toast is shown
        setState(() {
          listApiCall();
        });
      });
    } else {
      // Registration failed
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Delete failed!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
      print('Response body: ${response.body}');
    }
  }

  Future<List<dynamic>> listApiCall() async {
    final response = await http.get(
      Uri.parse("https://gorest.co.in/public/v2/users"),
      headers: {
        'Authorization': 'Bearer $bearerTkn',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData is List) {
        return jsonData;
      } else {
        throw Exception('Invalid JSON structure');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> listApiCallBySearch(String nameSearch) async {
    final response = await http.get(
      Uri.parse("https://gorest.co.in/public/v2/users?name=$nameSearch"),
      headers: {
        'Authorization': 'Bearer $bearerTkn',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData is List) {
        return jsonData;
      } else {
        throw Exception('Invalid JSON structure');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
            title: const Text("CRUD User"), automaticallyImplyLeading: false,
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
          mainAxisSize: MainAxisSize.max,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 5),
              child: Text(
                'Below are the list of user',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                  child: SizedBox(
                    width: 300,
                    child: TextFormField(
                      controller: searchBarController,
                      decoration: InputDecoration(
                        labelText: 'Search user by name',
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        hintText: 'Khai',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black87,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[400],
                        contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(24, 24, 20, 24),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.search_sharp,
                      color: Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                        listApiCallBySearch(searchBarController.text);
                      },
                  ),
                ),
              ],
            ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<dynamic>>(
                future: isSearching ? listApiCallBySearch(searchBarController.text) : listApiCall(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Center(child: Text('No list of users.'));
                  } else {
                    // Use a cast to assign snapshot.data to listResponse
                    listResponse = (snapshot.data!).cast<Map<String, dynamic>>();
            
                    return SizedBox(
                      // height: MediaQuery.of(context).size.height - 300,
                      height: 500,
                      child: ListView.builder(
                        itemCount: listResponse.length,
                        itemBuilder: (context, index) {
                          final user = listResponse[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(borderRadius:BorderRadius.circular(25), color: Colors.lightBlueAccent,),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('ID: ${user['id']}'),
                                          Text('Name: ${user['name']}'),
                                          Text('Email: ${user['email']}'),
                                          Text('Gender: ${user['gender']}'),
                                          Text('Status: ${user['status']}'),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            idUpdController.text = user['id'].toString();
                                            nameUpdController.text = user['name'];
                                            emailUpdController.text = user['email'];
                                            gdrUpd = user['gender'];
                                            stsUpd = user['status'];
                                        
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Update user ${user['name']}'),
                                                  content: SingleChildScrollView(
                                                    // Wrap the content in a SingleChildScrollView
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          keyboardType: TextInputType
                                                              .emailAddress,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'ID',
                                                          ),
                                                          controller: idUpdController,
                                                          readOnly: true,
                                                        ),
                                                        TextField(
                                                          keyboardType: TextInputType
                                                              .emailAddress,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Email',
                                                          ),
                                                          controller: emailUpdController,
                                                        ),
                                                        TextField(
                                                          keyboardType:
                                                              TextInputType.text,
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Name',
                                                          ),
                                                          controller: nameUpdController,
                                                        ),
                                                        FormBuilderRadioGroup(
                                                          name: 'status',
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Status',
                                                          ),
                                                          initialValue: stsUpd,
                                                          options: const [
                                                            FormBuilderFieldOption(
                                                                value: 'active'),
                                                            FormBuilderFieldOption(
                                                                value: 'inactive'),
                                                          ],
                                                          onChanged: (value) {
                                                            stsUpd = value.toString();
                                                            // Update status value
                                                          },
                                                        ),
                                                        FormBuilderRadioGroup(
                                                          name: 'gender',
                                                          decoration:
                                                              const InputDecoration(
                                                            labelText: 'Gender',
                                                          ),
                                                          initialValue: gdrUpd,
                                                          options: const [
                                                            FormBuilderFieldOption(
                                                                value: 'male'),
                                                            FormBuilderFieldOption(
                                                                value: 'female'),
                                                          ],
                                                          onChanged: (value) {
                                                            gdrUpd = value.toString();
                                                            // Update gender value
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Save',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        // Perform validation and save the weight and height data
                                                        if (idUpdController
                                                                .text.isNotEmpty &&
                                                            emailUpdController
                                                                .text.isNotEmpty &&
                                                            nameUpdController
                                                                .text.isNotEmpty &&
                                                            stsUpd.isNotEmpty &&
                                                            gdrUpd.isNotEmpty) {
                                                          update(
                                                              idUpdController.text,
                                                              emailUpdController.text,
                                                              nameUpdController.text,
                                                              stsUpd,
                                                              gdrUpd);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                            msg:
                                                                "Please fill in all fields!",
                                                            toastLength:
                                                                Toast.LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity.CENTER,
                                                            fontSize: 16.0,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () async {
                                            idDel = user['id'].toString();
                                        
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Delete user ${user['name']}'),
                                                  content: SingleChildScrollView(
                                                    // Wrap the content in a SingleChildScrollView
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text('Do you wish your continuation to delete id: ${user['id'].toString()}')
                                                      ],
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        idDel = '';
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        // Perform validation and save the weight and height data
                                                        if (idDel.isNotEmpty) {
                                                          delete(idDel);
                                                        } else {
                                                          Fluttertoast.showToast(
                                                            msg:
                                                                "ID Not Detected!!",
                                                            toastLength:
                                                                Toast.LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity.CENTER,
                                                            fontSize: 16.0,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Add new user'),
                      content: SingleChildScrollView(
                        // Wrap the content in a SingleChildScrollView
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                              ),
                              controller: emailController,
                            ),
                            TextField(
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              controller: nameController,
                            ),
                            TextField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: 'Status',
                              ),
                              controller: statusController,
                              readOnly: true,
                            ),
                            FormBuilderRadioGroup(
                              name: 'gender',
                              decoration: const InputDecoration(
                                labelText: 'Gender',
                              ),
                              initialValue: gender,
                              options: const [
                                FormBuilderFieldOption(value: 'male'),
                                FormBuilderFieldOption(value: 'female'),
                              ],
                              onChanged: (value) {
                                gender = value.toString();
                                // Update gender value
                              },
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          onPressed: () {
                            String status = 'active';
                            // Perform validation and save the weight and height data
                            if (emailController.text.isNotEmpty &&
                                nameController.text.isNotEmpty &&
                                statusController.text.isNotEmpty) {
                              create(emailController.text, nameController.text,
                                  status, gender);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please fill in all fields!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                fontSize: 16.0,
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Add New User'),
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
