import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart'; // Import the registration screen
import 'connection_class.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future _checkLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String storedEmail = prefs.getString('user_email') ?? "";
    // String storedPassword = prefs.getString('user_password') ?? "";
    var baseUrl = ConnectionClass.ipUrl;
    var url = Uri.parse("${baseUrl}Login.php");
    var response = await http.post(url, body: {
      "username": email,
      "password": password,
    });

    var userData = json.decode(response.body);
    if (userData == "Success") {
      prefs.setString('user_email', email);
      prefs.setString('user_password', password);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "userID and password doesn't exist!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        fontSize: 16.0,
      );
    }
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
          title: const Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Enter your email',
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Enter your Password',
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Check login credentials and navigate to the home screen if valid
                  _checkLogin(context);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Text("Don't Have Account? "),
              TextButton(
                onPressed: () {
                  // Navigate to the registration screen
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterWidget()));
                },
                child: const Text('Register Here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
