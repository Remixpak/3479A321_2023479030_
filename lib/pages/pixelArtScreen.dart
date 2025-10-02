import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/pages/my_home_page.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_lab2/providers/configurationData.dart';

class Pixelartscreen extends MyHomePage
{
  
  const Pixelartscreen({super.key, required super.title});
  @override
   PixelartscreenState createState() => PixelartscreenState();


  
}
class PixelartscreenState extends State<Pixelartscreen>
{
  int _sizeGrid = 32;
  @override
  void initState() {
   _sizeGrid = context.read<AppData>().size;
    Logger().d("initState() called: " + _sizeGrid.toString());
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

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Pixel Art Screen"),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Go Back'),
      ),
    ],
  ),
),
      
    ); 
   }

}