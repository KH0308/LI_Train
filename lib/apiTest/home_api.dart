import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:li_train/apiTest/boring_activity.dart';
import 'package:li_train/apiTest/crud_user.dart';
import 'package:li_train/apiTest/gender_guess.dart';
import 'package:li_train/apiTest/generate_ran_user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:li_train/apiTest/profile.dart';
import 'package:li_train/models/weather_model.dart';
import 'package:li_train/services/weather_service.dart';
import 'login_api.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class HomeApiWidget extends StatefulWidget {
  const HomeApiWidget({Key? key}) : super(key: key);

  @override
  State<HomeApiWidget> createState() => _HomeApiWidgetState();
}

class _HomeApiWidgetState extends State<HomeApiWidget> {
  String? storedIC, storedPassword, storeTkn;
  String viewIC = "";
  String viewPassword = "";
  String viewToken = "";
  // late Map mapResponse;
  // List? listResponse;
  String fName = "";
  String lName = "";
  String imgLink = "https://reqres.in/img/faces/10-image.jpg";
  // String imgLink = "";
  DateTime timeBackPressed = DateTime.now();

  // api key weather
  final wthrService = WeatherService('93b3f17251dd459894112334232410');
  Weather? wthr;
  // fetch weather
  fetchWeather() async {
    String cityName = await wthrService.getCurrentCity();

    try {
      final weather = await wthrService.getWeather(cityName);
      setState(() {
        wthr = weather;
      });
    } catch (e) {
      print(e);
    }
  }
  // weather animation

  @override
  void initState() {
    _loadName();
    profileApicall();
    fetchWeather();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    storedIC = prefs.getString('user_email');
    storedPassword = prefs.getString('user_password');
    storeTkn = prefs.getString('user_token');

    setState(() {
      viewIC = storedIC ??
          ''; // Use the null-aware operator to provide a default value if null
      viewPassword = storedPassword ?? '';
      viewToken = storeTkn ?? '';
    });
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
        fName = data['firstname'].toString();
        lName = data['email'].toString();
        // imgLink = data['avatar'].toString();
        // imgLink = 'https://reqres.in/img/faces/10-image.jpg';
      });
      print(response.body);
    } else {
      print(response.body);
    }
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
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          automaticallyImplyLeading: false,
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
        body: Stack(
          children: [
            // Add a GIF as the background
            Image.asset(
              'assets/gif/cloud.gif', // Replace with the path to your GIF
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${wthr?.cityName ?? 'Loading City...'}, ${wthr?.countryName ?? 'Loading Country...'}',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    fetchWeather();
                                  },
                                  icon: const Icon(Icons.location_on_rounded),
                                ),
                              ],
                            ),
                            Text(wthr?.dateTime != null
                                ? 'Last update: ${wthr?.dateTime}'
                                : 'Last update: Loading...'),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.person),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileWidget(
                                      uName: fName,
                                      uEmail: lName,
                                      imgLink: imgLink)));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(viewIC),
                          ),
                          Text(viewPassword),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        wthr?.temperature.toStringAsFixed(1) ?? '\u{231B}',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "°C",
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.displayMedium,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              wthr?.mainConditionText ??
                                  'N/A', // Provide a fallback value if wthr is null
                              style: GoogleFonts.roboto(
                                textStyle:
                                    Theme.of(context).textTheme.displayMedium,
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Lottie.asset('assets/gif/Sun.json'),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: const [
                        // Weather section
                        // WeatherWidget(),
                        // Text(viewToken),
                      ],
                    ),
                  ),
                ),
              ],
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
                            imgLink,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(fName),
                      ),
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Text(lName),
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
                          fName: fName, lName: lName, imgLink: imgLink)));
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
                          fName: fName, lName: lName, imgLink: imgLink)));
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
                          fName: fName, lName: lName, imgLink: imgLink)));
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
                          fName: fName, lName: lName, imgLink: imgLink)));
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
                  pref.remove("user_token");
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

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  // Replace with your JSON data
  final Map<String, dynamic> weatherData = {
    // Your weather data here
  };

  @override
  Widget build(BuildContext context) {
    // Weather data and widgets go here
    return Column(
      children: [
        Row(
          children: [
            Text(
              "28",
              style: GoogleFonts.roboto(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "°C",
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Cloudy",
                  style: GoogleFonts.roboto(
                    textStyle: Theme.of(context).textTheme.displayMedium,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
