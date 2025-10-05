import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  int _size = 16;
  int get size => _size;

  void setSize(int newSize) {
    _size = newSize;
    notifyListeners(); //segun entedí esto notifica a los widgets que dependan de este valor
  }

  String _palette = 'default';
  String get palette => _palette;
  void setPalette(String newPalette) {
    _palette = newPalette;
    notifyListeners();
  }
}
