import 'package:flutter/material.dart';

class ListArtScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pixel Art List')),
      /*body: Center(
        child: Text(
          'Lista de pixel art disponibles',
            
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

  final List<String> items = [
    'Pixel Art 1',
    'Pixel Art 2',
    'Pixel Art 3',
    'Pixel Art 4',
    'Pixel Art 5',
  ];
}
