import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:li_train/apiTest/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:li_train/apiTest/home_api.dart';

class LoginApiWidget extends StatefulWidget {
  const LoginApiWidget({Key? key}) : super(key: key);

  @override
  State<LoginApiWidget> createState() => _LoginApiWidgetState();
}

class _LoginApiWidgetState extends State<LoginApiWidget> {
  TextEditingController icController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime pre_backpress = DateTime.now();
  DateTime timeBackPressed = DateTime.now();
  String value = '';
  bool obsScrText = true;
  final formKey = GlobalKey<FormState>();
  bool loadingButton = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void login(String email, password) async {
    setState(() => loadingButton = true);
    String plyrId = 'fd4dbcf8-6ca8-4edb-b3ac-462576616f23';
    final isValidForm = formKey.currentState?.validate();
    if (isValidForm != false) {
      try {
        http.Response response = await http.post(
            Uri.parse(
                'https://staging.api.medkad.com/v1/login'), // Replace with your API endpoint
            headers: {
              'Accept': 'application/json'
            },
            body: {
              'ic_number': email,
              'password': password,
              'device_name': '',
              'player_id': plyrId
            });

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);

          if (data['result'] == true) {
            setState(() => loadingButton = false);
            // Extract the token from the JSON response
            String token = data['token'].toString();

            // Store the token in SharedPreferences
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('user_email', email);
            prefs.setString('user_password', password);
            prefs.setString('user_token', token);

            Fluttertoast.showToast(
              msg: "Check login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: ((context) => const LoadingWidget())),
            );
          } else {
            setState(() => loadingButton = false);
            Fluttertoast.showToast(
              msg: "Not found username",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
            print(response.body);
          }
        } else {
          setState(() => loadingButton = false);
          Fluttertoast.showToast(
            msg: "Cannot login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          print(response.body);
        }
      } catch (e) {
        setState(() => loadingButton = false);
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
    setState(() => loadingButton = false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          Fluttertoast.showToast(
            msg: "Press back again to exit.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Api'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  controller: icController,
                  decoration: InputDecoration(
                    hintText: 'exp:9082735161',
                    labelText: 'IC Number',
                    fillColor: const Color.fromARGB(255, 207, 207, 207),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'exp:*****',
                    fillColor: const Color.fromARGB(255, 207, 207, 207),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obsScrText ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          obsScrText = !obsScrText;
                        });
                      },
                    ),
                  ),
                  obscureText: obsScrText,
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    loadingButton
                        ? null
                        : login(icController.text.toString(),
                            passwordController.text.toString());
                  },
                  child: loadingButton
                      ? Container(
                          width: 18,
                          height: 18,
                          padding: const EdgeInsets.all(2.0),
                          child: const CircularProgressIndicator(
                            color: Color.fromARGB(255, 0, 0, 0),
                            strokeWidth: 3,
                          ),
                        )
                      : Container(
                          decoration:
                              const BoxDecoration(color: Colors.blueAccent),
                          margin: const EdgeInsets.only(left: 50, right: 50),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
