import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '/apiTest/login_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/apiTest/home_api.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  State<LoadingWidget> createState() => LoadingWidgetState();
}

class LoadingWidgetState extends State<LoadingWidget> {
  String? tokenStore;

  @override
  void initState() {
    super.initState();
    checkTokenStatus();
  }

  checkTokenStatus() async {
    await Future.delayed(const Duration(seconds: 5), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //to check whether the token has been saved in local storage or not
      final String tokenStore = prefs.getString('user_token').toString();
      final String icStore = prefs.getString('user_email').toString();
      final String passStore = prefs.getString('user_password').toString();
      if (tokenStore.isEmpty ||
          tokenStore == 'null' && icStore.isEmpty ||
          icStore == 'null' && passStore.isEmpty ||
          passStore == 'null') {
        Fluttertoast.showToast(
          msg: "Token not found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => const LoginApiWidget())),
        );
      } else {
        Fluttertoast.showToast(
          msg: "Successful login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => const HomeApiWidget())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Center(
        child: Lottie.asset('assets/gif/loading.json'),
      ),
    );
  }
}