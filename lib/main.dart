import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterpostapi/ui/PostList.dart';

void main() {
  runApp(const MyApp());
}
/*
       CreatedBy: Ankit Agrahari
       CreatedDate: 15/04/2022
       Description: This class is main entry point of app and Show the Splash screen.
*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Builder(
        builder:  (context) => Scaffold(appBar: AppBar(title: const Text('Post App'),

        ), body: const MyHomePage(),
        )));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    //Splash Screen Timer for 3 Seconds.
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                PostList()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/splash.png', width: 200, height: 200,),
            SizedBox(height: 15,),
            const Text('Loading...', style:  TextStyle(fontSize: 20, color: Colors.blue,))
          ],
        )
        );
    }
}
