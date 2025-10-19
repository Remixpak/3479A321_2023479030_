import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/about.dart';
import 'package:flutter_aplication_lab2/pages/list_art.dart';
import 'package:flutter_aplication_lab2/pages/list_creation.dart';
import 'package:flutter_aplication_lab2/pages/pixelArtScreen.dart';
import 'package:flutter_aplication_lab2/pages/settings.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _currentColor = const Color.fromARGB(255, 255, 255, 255);

  File? _lastImage;

  void ChangeColor(
    Color newColor,
  ) //ignorar, esto lo que hacia era cambiar en base al numero del contador
  {
    setState(() {
      _currentColor = newColor; //actualiza el color actual
    });
  }

  void changeColor2() {
    setState(() {
      if (_currentColor ==
          const Color.fromARGB(255, 255, 255, 255)) //color base
      {
        _currentColor = const Color.fromARGB(
          255,
          118,
          68,
          233,
        ); //cambia a morado
      } else if (_currentColor ==
          const Color.fromARGB(255, 118, 68, 233)) //morado
      {
        _currentColor = const Color.fromARGB(
          255,
          57,
          205,
          250,
        ); //cambia a celeste
      } else {
        _currentColor = const Color.fromARGB(
          255,
          255,
          255,
          255,
        ); //cambia a blanco
      }
    });
  }

  void share() {
    print("compartir");
  }

  void to_ListArt() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListArtScreen()),
    );
  }

  void to_ListCreation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListCreationScreen()),
    );
  }

  void to_pixelArtScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pixelartscreen()),
    );
  }

  void to_settings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    );
  }

  Future<void> getLastImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    // Filtramos solo archivos .png
    final imageFiles = files
        .where(
          (file) => file is File && file.path.toLowerCase().endsWith('.png'),
        )
        .map((file) => File(file.path))
        .toList();

    if (imageFiles.isEmpty) return;

    imageFiles.sort((a, b) {
      final aTime = a.lastModifiedSync();
      final bTime = b.lastModifiedSync();
      return bTime.compareTo(aTime);
    });

    setState(() {
      _lastImage = imageFiles.first;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _currentColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutScreen()),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.settings), onPressed: to_settings),
        ],
      ),
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.all(16.0),
          color: Color.fromARGB(255, 95, 207, 170),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Pixel Art sobre una grrilla personalizable'),
              //Image.asset("assets/Pixel-Art-Hot-Pepper-2-1.webp", width: 100,height: 100,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/Pixel-Art-Hot-Pepper-2-1.webp',
                      width: 400,
                      height: 400,
                    ),
                    Image.asset(
                      'assets/Pixel-Art-Pizza-2.webp',
                      width: 400,
                      height: 400,
                    ),
                    Image.asset(
                      'assets/Pixel-Art-Watermelon-3.webp',
                      width: 400,
                      height: 400,
                    ),
                    if (_lastImage != null)
                      Image.file(
                        _lastImage!,
                        width: 400,
                        height: 400,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),

              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                spacing: 4,
                children: [
                  ElevatedButton(
                    onPressed: share,
                    child: const Icon(Icons.share),
                  ),
                  ElevatedButton(
                    onPressed: to_ListArt,
                    child: const Icon(Icons.create),
                  ),
                  ElevatedButton(
                    onPressed: to_ListCreation,
                    //onPressed: to_pixelArtScreen,
                    //onPressed: to_settings,
                    child: const Icon(Icons.list),
                  ),
                  ElevatedButton(
                    onPressed: to_pixelArtScreen,
                    child: const Icon(Icons.brush),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ChangeColor(Colors.primaries[_counter % Colors.primaries.length]);}
          changeColor2();
          //print("Boton apretado");
        },
        child: const Icon(Icons.color_lens_outlined),
      ),*/
      persistentFooterButtons: ChangeCounterValue,
    );
  }

  List<Widget> get ChangeCounterValue {
    return <Widget>[
      //botones persistentes en el pie de la pantalla
      /*ElevatedButton(
        onPressed: _incrementCounter,

        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      ElevatedButton(
        onPressed: _decrementCounter,
        child: const Icon(Icons.remove),
      ),
      ElevatedButton(
        onPressed: _resetCounter,

        child: const Icon(Icons.refresh),
      ),*/
      ElevatedButton(
        onPressed: () {
          getLastImage();
        },
        child: const Icon(Icons.save_alt_outlined),
      ),
      ElevatedButton(
        onPressed: () {
          changeColor2();
        },
        child: const Icon(Icons.color_lens_outlined),
      ),
    ];
  }
}
