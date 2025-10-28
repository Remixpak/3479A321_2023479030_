import 'package:flutter/material.dart';
import 'package:flutter_aplication_lab2/services/sharedPreferences.dart';

class AppData extends ChangeNotifier {
  int _size = 16;
  int get size => _size;
  final SharedPreferencesService _prefsService = SharedPreferencesService();
  /*void setSize(int newSize) {
    _size = newSize;
    notifyListeners(); //segun entedí esto notifica a los widgets que dependan de este valor
  }*/

  String _palette = 'default';
  String get palette => _palette;
  /*void setPalette(String newPalette) {
    _palette = newPalette;
    notifyListeners();
  }*/

  double _backgroundOpacity = 1.0;
  double get backgroundOpacity => _backgroundOpacity;

  AppData() {
    loadData();
  }

  Future<void> loadData() async {
    _size = await _prefsService.LoadSize();
    _palette = await _prefsService.LoadPalette();
    _backgroundOpacity = await _prefsService.LoadBackgroundOpacity();

    notifyListeners();
  }

  Future<void> setSize(int newSize) async {
    _size = newSize;
    await _prefsService.saveSize(newSize);
    notifyListeners();
  }

  Future<void> setPalette(String newPalette) async {
    _palette = newPalette;
    await _prefsService.savePalette(newPalette);
    notifyListeners();
  }

  Future<void> setBackgroundOpacity(double newOpacity) async {
    _backgroundOpacity = newOpacity;
    await _prefsService.saveBackgroundOpacity(newOpacity);
    notifyListeners();
  }

  /*void addCreation(String filePath)
  {

  }*/
}
