import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  String KeySize = 'size';
  String KeyPalette = 'palette';

  Future<void> saveSize(int size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KeySize, size);
  }

  Future<int> LoadSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(KeySize) ?? 16;
  }

  Future<void> savePalette(String palette) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(KeyPalette, palette);
  }

  Future<String> LoadPalette() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyPalette) ?? 'default';
  }

  Future<void> saveBackgroundOpacity(double opacity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('background_opacity', opacity);
  }

  Future<double> LoadBackgroundOpacity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('background_opacity') ?? 1.0;
  }
}
