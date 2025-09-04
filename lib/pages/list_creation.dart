import 'package:flutter/material.dart';


class ListCreationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Creation List'),
      ),
      body: Center(
        child: Text(
          'Lista de creaciones disponibles',
            
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}