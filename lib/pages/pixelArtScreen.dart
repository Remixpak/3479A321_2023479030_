import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/my_home_page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_lab2/providers/configurationData.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

/*class Pixelartscreen extends MyHomePage {
  const Pixelartscreen({super.key, required super.title});
  @override
  PixelartscreenState createState() => PixelartscreenState();
}*/
class Pixelartscreen extends StatefulWidget {
  const Pixelartscreen({super.key});
  @override
  PixelartscreenState createState() => PixelartscreenState();
}

class PixelartscreenState extends State<Pixelartscreen> {
  int _sizeGrid = 32;
  String _palette = "default";
  bool _showNumbers = true;

  Color _selectedColor = Colors.black;
  final List<Color> _listColors = [
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.brown,
    Colors.grey,
    Colors.pink,
  ];
  late List<Color> _cellColors = List<Color>.generate(
    _sizeGrid * _sizeGrid,
    (index) => Colors.transparent,
  );

  String? _lastSavedPath;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sizeGrid = context.read<AppData>().size;
    _palette = context.read<AppData>().palette;
    _cellColors = List<Color>.generate(
      _sizeGrid * _sizeGrid,
      (index) => Colors.transparent,
    );
    Logger().d(
      "didChangeDependencies() called SizeGrid: " +
          _sizeGrid.toString() +
          " Palette: " +
          _palette,
    );
  }

  @override
  void didUpdateWidget(covariant Pixelartscreen oldWidget) {
    Logger().d("didUpdateWidget() called");
  }

  @override
  void deactivate() {
    Logger().d("deactivate() called");
  }

  @override
  void dispose() {
    Logger().d("dispose() called");
    super.dispose();
  }

  @override
  void reassemble() {
    Logger().d("reassemble() called");
  }

  Future<void> _savePixelArt() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(
      recorder,
      Rect.fromLTWH(0, 0, _sizeGrid * 20.0, _sizeGrid * 20.0),
    );
    for (int row = 0; row < _sizeGrid; row++) {
      for (int col = 0; col < _sizeGrid; col++) {
        final color = _cellColors[row * _sizeGrid + col];
        final paint = Paint()..color = color;
        final rect = Rect.fromLTWH(col * 20.0, row * 20.0, 20.0, 20.0);
        canvas.drawRect(rect, paint);
      }
    }
    final picture = recorder.endRecording();
    final image = await picture.toImage(_sizeGrid * 20, _sizeGrid * 20);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final imageBytes = byteData!.buffer.asUint8List();
    final directory = await getApplicationDocumentsDirectory();
    final filePath =
        '${directory.path}/pixel_art_${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    await file.writeAsBytes(imageBytes);
    setState(() {
      _lastSavedPath = filePath;
    });
    //Logger.d("Pixel art saved to: $filePath");
    //context.read<AppData>().addCreation(filePath);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pixel art saved to: $filePath'),
        action: SnackBarAction(
          label: 'Compartir',
          onPressed: () {
            // compartir desde el SnackBar
            _shareLastSaved();
          },
        ),
      ),
    );
  }

  Future<void> _shareLastSaved() async {
    if (_lastSavedPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay imagen para compartir')),
      );
      return;
    }
    try {
      // convert path -> XFile and use shareXFiles
      await Share.shareXFiles([XFile(_lastSavedPath!)], text: 'Mi pixel art');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al compartir: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Creation Process'),
        actions: [
          IconButton(
            icon: Icon(_showNumbers ? Icons.visibility : Icons.visibility_off),
            tooltip: _showNumbers ? 'Ocultar números' : 'Mostrar números',
            onPressed: () {
              setState(() {
                _showNumbers = !_showNumbers;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        // Wrap the Column with SafeArea
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$_sizeGrid x $_sizeGrid'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'Enter title',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          //Logger.d('Title entered: $value');
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //logger.d('Button pressed');
                      _savePixelArt();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
            // GridView above the footer
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _sizeGrid,
                ),
                itemCount: _sizeGrid * _sizeGrid,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _cellColors[index] = _selectedColor;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(1),

                      color: _cellColors[index],
                      child: Center(
                        child: _showNumbers
                            ? Text(
                                '$index',
                                style: TextStyle(
                                  color: _cellColors[index] == Colors.black
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Footer with selectable colors
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _listColors.map((color) {
                    final bool isSelected = color == _selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.all(isSelected ? 12 : 8),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        width: isSelected ? 36 : 28,
                        height: isSelected ? 36 : 28,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
