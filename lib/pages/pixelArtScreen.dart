import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/my_home_page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_lab2/providers/configurationData.dart';

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
  @override
  void initState() {
    _sizeGrid = context.read<AppData>().size;
    _palette = context.read<AppData>().palette;
    Logger().d(
      "initState() called SizeGrid: " +
          _sizeGrid.toString() +
          " Palette: " +
          context.read<AppData>().palette,
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    Logger().d("didChangeDependencies() called");
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

  /*@override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();

    if (_cellColors.length != appData.size * appData.size) {
      _cellColors = List<Color>.generate(
        appData.size * appData.size,
        (index) => Colors.transparent,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pixel Art (${appData.size}x${appData.size})'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${appData.size} x ${appData.size}'),
                  ElevatedButton(
                    onPressed: () {
                      Logger().d('Button pressed');
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: appData.size,
                ),
                itemCount: appData.size * appData.size,
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
                    ),
                  );
                },
              ),
            ),

       
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
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creation Process')),
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
                        child: Text(
                          '$index',
                          style: TextStyle(
                            color: _cellColors[index] == Colors.black
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
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
