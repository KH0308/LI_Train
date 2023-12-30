import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'connection_class.dart';
import 'package:http/http.dart' as http;

class RegisterWidget extends StatefulWidget{
  const RegisterWidget({Key? key}) : super(key: key);
  
  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();

}

class _RegisterWidgetState extends State<RegisterWidget>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String storedName = "";
  String storedEmail = "";
  String storedPassword = "";
  String? errorText;
  String? errorTextPwd;

  @override
  void initState() {
    super.initState();
    errorText = null; // Initialize errorText to null
    errorTextPwd = null; // Initialize errorTextPwd to null
  }

  bool _isEmailValid(String email) {
    // Email validation regex pattern
    final emailPattern = r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$';
    return RegExp(emailPattern).hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    // Password validation regex pattern (at least 8 characters, 1 special character, 1 uppercase letter)
    final passwordPattern = r'^(?=.*[A-Z])(?=.*[\W_]).{8,}$';
    return RegExp(passwordPattern).hasMatch(password);
  }

  // Function to save the user's name to SharedPreferences.
  Future _saveName(BuildContext context) async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var baseUrl = ConnectionClass.ipUrl;
      var url = Uri.parse("${baseUrl}Register.php");
      var response = await http.post(url, body: {
        "emailID": email,
        "password": password,
        "name": name,
      });

      if (response.statusCode == 200) {
        prefs.setString('user_email', email);
        prefs.setString('user_password', password);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeWidget()),
        );
      } else {
        Fluttertoast.showToast(
          msg: "userID and password has exist!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          fontSize: 16.0,
        );
      }
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
          title: const Text("Register"),
          automaticallyImplyLeading: false, // Disable the back button in the app bar
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name'
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  errorText: errorText
                  // _isEmailValid(emailController.text) ? null : "Invalid email format",
                ),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Enter your Password',
                  errorText: errorTextPwd,
                  // _isPasswordValid(passwordController.text)
                  //     ? null
                  //     : "At least 8 characters with special and 1 uppercase character",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text;
                  final password = passwordController.text;
                  setState(() {
                    errorText = null; // Reset email error text
                    errorTextPwd = null; 
                  });

                  if (!_isEmailValid(email)) {
                    setState(() {
                      errorText = "Please enter email format exp: 123@server.com";
                      
                    });
                    Fluttertoast.showToast(
                      msg: "Invalid email format",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  } else if (!_isPasswordValid(password)) {
                    setState(() {
                      errorTextPwd = "At least 8 character with special and 1 case character";
                    });
                    Fluttertoast.showToast(
                      msg: "Invalid password format",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    
                  } else {
                    errorText = null; // Reset email error text
                    errorTextPwd = null; // Reset password error text
                    _saveName(context);
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Have Account? '),
                  TextButton(
                    onPressed: () {
                      // Navigate to the registration screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginWidget()));
                    },
                    child: const Text('Login Here'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}