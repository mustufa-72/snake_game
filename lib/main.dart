import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:snake_game/firebase_options.dart';
//import 'package:firebase_database/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/home_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //var DefaultFirebaseOptions;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  //options: const FirebaseOptions(
   // apiKey: "AIzaSyCwq3lKSgeOEgZ5h3aXmDwGpKXlxdiq0OU",
    //appId: "1:742425198469:android:7bb825f0ed5b0979db8eec",
    //messagingSenderId: "742425198469",
    //projectId: "snakegame1-e7720"
  //)
  );
  //MobileAds.instance.initialize();
       // apiKey: "AIzaSyCwq3lKSgeOEgZ5h3aXmDwGpKXlxdiq0OU",
       // appId: "1:742425198469:android:7bb825f0ed5b0979db8eec",
       // messagingSenderId: "742425198469",
       // projectId: "snakegame1-e7720"
  runApp(const MyApp());
}

/// comment
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // title: Text(widget.title),
      ),
        backgroundColor: Colors.black,
      body: HomePage()
      );// This trailing comma makes auto-formatting nicer for build methods.

  }
}
