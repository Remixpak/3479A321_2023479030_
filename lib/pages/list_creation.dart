import 'package:flutter/material.dart';

class ListCreationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pixel Creation List')),
      /*body: Center(
        child: Text(
          'Lista de creaciones disponibles',
            
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),*/
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 40),
                SizedBox(width: 16),
                Text(
                  items[index],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

final List<String> items = [
  'Pixel creation 1',
  'Pixel creation 2',
  'Pixel creation 3',
  'Pixel creation 4',
  'Pixel creation 5',
];
