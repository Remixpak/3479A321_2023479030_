import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/my_home_page.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: Text(
          'Sobre la app',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => return_to_home(context),
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ],
    );
  }

  void return_to_home(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage(title: "Inicio")),
    );
  }
}



/*

ElevatedButton(
        onPressed: _incrementCounter,

        child: const Icon(Icons.add),
      ), 
*/ 