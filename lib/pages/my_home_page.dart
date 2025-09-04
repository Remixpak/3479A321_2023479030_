import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Color _currentColor = const Color.fromARGB(255, 255, 255, 255);

  void ChangeColor(
    Color newColor,
  ) //ignorar, esto lo que hacia era cambiar en base al numero del contador
  {
    setState(() {
      _currentColor = newColor;//actualiza el color actual
    });
  }

  void changeColor2() {
    setState(() {
      if (_currentColor ==
          const Color.fromARGB(255, 255, 255, 255))//color base
      {
        _currentColor = const Color.fromARGB(
          255,
          118,
          68,
          233,
        ); //cambia a morado
      } else if (_currentColor ==
          const Color.fromARGB(255, 118, 68, 233))//morado
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

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: _currentColor,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
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
                ],
              ),
            ),

            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //ChangeColor(Colors.primaries[_counter % Colors.primaries.length]);}
          changeColor2();
          //print("Boton apretado");
        },
        child: const Icon(Icons.color_lens_outlined),
      ),
      persistentFooterButtons: ChangeCounterValue,
    );
  }

  List<Widget> get ChangeCounterValue {
    return <Widget>[
      //botones persistentes en el pie de la pantalla
      FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      FloatingActionButton(
        onPressed: _decrementCounter,
        tooltip: 'Decrement',
        child: const Icon(Icons.remove),
      ),
      FloatingActionButton(
        onPressed: _resetCounter,
        tooltip: 'Reset',
        child: const Icon(Icons.refresh),
      ),
    ];
  }
}
