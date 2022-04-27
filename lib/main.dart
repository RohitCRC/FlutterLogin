import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterlogin/activity/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Login';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SanFrancisco',
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: true,
          body: const LoginScreen(),
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              _title,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Login text Widget
        Container(
            height: 200,
            width: 400,
            alignment: Alignment.center,
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              // textAlign: TextAlign.center,
            ),
          ),

        Container(
          height: 60,
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
            controller: usernameController, // Controller for Username
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Username",
                contentPadding: EdgeInsets.all(20)),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
          ),
        ),
        Container(
          height: 60,
          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: TextField(
              controller: passwordController, // Controller for Password
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password",
                contentPadding: EdgeInsets.all(20),
              ),
              onEditingComplete: () => FocusScope.of(context).nextFocus()),
        ),
        Container(
            height: 60,
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shadowColor: Colors.black),
              onPressed: () async {
                print(usernameController.text);
                print(passwordController.text);
                final queryParameters = {
                  'Str_UserName': usernameController.text,
                  'Str_Password': passwordController.text,
                };
                var response = await http.get(Uri.http(
                    'crconline.in',
                    'crcapp/webmethods/apiwebservice.asmx/Login',
                    queryParameters));
                var jsonData = jsonDecode(response.body);

                // Obtain shared preferences.
                final prefs = await SharedPreferences.getInstance();

                List<Task> taskname = [];
                for (var u in jsonData) {
                  Task task = Task(u["EmployeeName"]);
                  prefs.setString("ID", u["UserId"].toString());
                  prefs.setString("CODE", u["EmployeeCode"].toString());
                  prefs.setString("NAME", u["EmployeeName"].toString());

                  taskname.add(task);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Login Success :- "+u["EmployeeName"]),
                  ));
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );

                print(taskname.length);
              },
            )),
      ],
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class Task {
  final String taskname;

  Task(this.taskname);
}
