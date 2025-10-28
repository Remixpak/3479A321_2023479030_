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
import 'package:image_picker/image_picker.dart';
import 'package:flutter_aplication_lab2/models/pixelArt.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

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

  File? _backgroundImage;
  double _backgroundOpacity = 0.5;

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

  // New controllers for title / description
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

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

  // helper: convert Color <-> int (ARGB)
  int _colorToInt(Color c) => c.value;
  Color _colorFromInt(int v) => Color(v);

  // Saves PNG + JSON metadata (PixelArt) in app documents directory
  Future<void> _savePixelArtWithMetadata() async {
    final now = DateTime.now();
    final prefix = 'pixel_art_${now.millisecondsSinceEpoch}';

    // 1) render image (same as previous _savePixelArt)
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
    final pngPath = '${directory.path}/${prefix}.png';
    final pngFile = File(pngPath);
    await pngFile.writeAsBytes(imageBytes);

    // 2) build PixelArt-compatible JSON metadata
    final id = prefix;
    final authorId = 'local';
    final title = _titleController.text.isNotEmpty
        ? _titleController.text
        : 'Untitled $id';
    final description = _descController.text;
    final sizeMap = {'width': _sizeGrid, 'height': _sizeGrid};
    // store palette as hex strings (optional). keep provided palette name for reference
    final paletteList = _listColors
        .map((c) => c.value.toRadixString(16))
        .toList();
    // gridData as list of ARGB ints
    final gridData = _cellColors.map((c) => _colorToInt(c)).toList();

    final pixelArtJson = {
      'id': id,
      'authorId': authorId,
      'title': title,
      'description': description,
      'size': sizeMap,
      'palette': paletteList,
      'gridData': gridData,
      'createdAt': now.toIso8601String(),
      'lastModifiedAt': now.toIso8601String(),
      'png': '${prefix}.png', // relative filename
    };

    final jsonPath = '${directory.path}/${prefix}.json';
    final jsonFile = File(jsonPath);
    await jsonFile.writeAsString(jsonEncode(pixelArtJson));

    setState(() {
      _lastSavedPath = pngPath;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Guardado: $pngPath'),
        action: SnackBarAction(
          label: 'Compartir',
          onPressed: () => _shareLastSaved(),
        ),
      ),
    );
  }

  // show list of saved json creations and allow loading one
  Future<void> _showLoadDialog() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    final jsonFiles = files
        .where(
          (f) =>
              f is File &&
              f.path.toLowerCase().endsWith('.json') &&
              f.path.contains('pixel_art_'),
        )
        .toList();

    if (jsonFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay creaciones guardadas')),
      );
      return;
    }

    final selection = await showDialog<File?>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Cargar Pixel Art'),
          children: jsonFiles.map((f) {
            final file = f as File;
            final name = file.path.split(Platform.pathSeparator).last;
            final content = file.readAsStringSync();
            String title = name;
            try {
              final map = jsonDecode(content);
              if (map is Map && map['title'] != null) title = map['title'];
            } catch (_) {}
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, file),
              child: ListTile(title: Text(title), subtitle: Text(name)),
            );
          }).toList(),
        );
      },
    );

    if (selection != null) {
      try {
        final content = await selection.readAsString();
        final map = jsonDecode(content) as Map<String, dynamic>;
        await _applyPixelArtFromJson(map);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar: $e')));
      }
    }
  }

  Future<void> _applyPixelArtFromJson(Map<String, dynamic> jsonMap) async {
    // validate and apply
    if (!jsonMap.containsKey('gridData') || !jsonMap.containsKey('size')) {
      throw Exception('JSON inválido');
    }
    final sizeMap = jsonMap['size'] as Map<String, dynamic>;
    final width = (sizeMap['width'] as num).toInt();
    final height = (sizeMap['height'] as num).toInt();
    final grid = (jsonMap['gridData'] as List)
        .map((e) => (e as num).toInt())
        .toList();

    setState(() {
      // if sizes differ, update _sizeGrid and rebuild _cellColors accordingly
      if (width != _sizeGrid) {
        _sizeGrid = width;
      }
      final expected = _sizeGrid * _sizeGrid;
      _cellColors = List<Color>.generate(expected, (index) {
        if (index < grid.length) {
          return _colorFromInt(grid[index]);
        } else {
          return Colors.transparent;
        }
      });
      // populate title/description controls if available
      _titleController.text = jsonMap['title']?.toString() ?? '';
      _descController.text = jsonMap['description']?.toString() ?? '';
    });
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

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/background_image.png';
      // Save the new image and delete the old one if it exists
      final newImage = File(pickedFile.path);
      if (_backgroundImage != null && _backgroundImage!.existsSync()) {
        _backgroundImage!.deleteSync();
      }
      newImage.copySync(filePath);
      setState(() {
        _backgroundImage = File(filePath);
      });
    }
  }

  void _deleteBackgroundImage() {
    if (_backgroundImage != null && _backgroundImage!.existsSync()) {
      _backgroundImage!.deleteSync();
    }
    setState(() {
      _backgroundImage = null;
    });
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
          IconButton(
            icon: const Icon(Icons.camera),
            onPressed: () {
              setState(() {
                _takePicture();
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
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('$_sizeGrid x $_sizeGrid'),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      controller: _titleController, // <-- use controller
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        hintText: 'Description (optional)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _savePixelArtWithMetadata,
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: _showLoadDialog,
                    child: const Text('Cargar'),
                  ),
                  ElevatedButton(
                    onPressed: _savePixelArt,
                    child: const Text('Submit'),
                  ),
                  if (_backgroundImage != null)
                    ElevatedButton.icon(
                      onPressed: _deleteBackgroundImage,
                      icon: const Icon(Icons.delete),
                      label: const Text('Eliminar fondo'),
                    ),
                  if (_backgroundImage != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Ajustar opacidad'),
                        SizedBox(
                          width: 180,
                          child: Slider(
                            value: context.watch<AppData>().backgroundOpacity,
                            min: 0.1,
                            max: 1.0,
                            divisions: 10,
                            label:
                                '${(context.watch<AppData>().backgroundOpacity * 100).toInt()}%',
                            onChanged: (value) {
                              context.read<AppData>().setBackgroundOpacity(
                                value,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            // GridView above the footer
            Expanded(
              child: Stack(
                children: [
                  if (_backgroundImage != null)
                    Opacity(
                      opacity: context.watch<AppData>().backgroundOpacity,
                      child: Image.file(
                        _backgroundImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  GridView.builder(
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
                ],
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
