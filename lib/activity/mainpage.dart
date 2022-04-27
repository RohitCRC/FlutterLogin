import 'package:flutter/material.dart';
import 'package:flutterlogin/main.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);


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
          appBar: AppBar(
            elevation: 0,
            title: const Text(
              "Main Dash",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          body: Center(
            child: ElevatedButton(
              child: const Text('Go Back'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ),
        ));
  }
}
