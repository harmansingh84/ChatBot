
import 'package:flutter/material.dart';
import 'package:myapp/Pages/home_page.dart';
import 'package:myapp/const.dart';
import 'package:flutter_gemini/flutter_gemini.dart';



void main() async{
  Gemini.init(apiKey: GEMINI_API_KEY);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
