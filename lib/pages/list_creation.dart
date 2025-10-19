import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListCreationScreen extends StatefulWidget {
  const ListCreationScreen({super.key});

  @override
  State<ListCreationScreen> createState() => _ListCreationScreenState();
}

class _ListCreationScreenState extends State<ListCreationScreen> {
  List<File> _savedImages = [];

  @override
  void initState() {
    super.initState();
    readImages();
  }

  Future<void> readImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    final imageFiles = files
        .where(
          (file) => file is File && file.path.toLowerCase().endsWith('.png'),
        )
        .map((file) => File(file.path))
        .toList();

    setState(() {
      _savedImages = imageFiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pixel Creation List')),
      body: _savedImages.isEmpty
          ? const Center(
              child: Text(
                'No hay pixel arts guardados todavía',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: _savedImages.length,
              itemBuilder: (context, index) {
                final imageFile = _savedImages[index];
                final imageName = imageFile.path.split('/').last;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: Image.file(
                      imageFile,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      imageName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
