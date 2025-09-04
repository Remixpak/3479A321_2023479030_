import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/about.dart';
import 'package:flutter_aplication_lab2/pages/list_art.dart';
import 'package:flutter_aplication_lab2/pages/list_creation.dart';
import 'package:flutter_aplication_lab2/pages/my_home_page.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    var logger = Logger();
    logger.d("Logger is working!");

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        fontFamily: 'SuperMario',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 255, 170),
        ),
      ),
      home: MyHomePage(title: '2023479030'),
      //home: ListArtScreen(),
      //home: ListCreationScreen(),
      //home: AboutScreen(),
    );
  }
}
