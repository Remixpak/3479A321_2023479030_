import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_aplication_lab2/providers/configurationData.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appData = context.watch<AppData>();

    final pixelSizes = [16, 18, 20, 24, 32];
    final colorPalettes = ['default', 'Retro', 'Neon', 'Pastel', 'Oscura'];

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Configuracion del tamaño ---
            const Text(
              'Tamaño del pixel art:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: appData.size,
              items: pixelSizes
                  .map((s) => DropdownMenuItem(value: s, child: Text('$s px')))
                  .toList(),
              onChanged: (value) {
                if (value != null) context.read<AppData>().setSize(value);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),

            // --- Configuracion de la paleta ---
            const Text(
              'Paleta de colores:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: appData.palette,
              items: colorPalettes
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (value) {
                if (value != null) context.read<AppData>().setPalette(value);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),
            Text('Tamaño actual: ${appData.size}px'),
            Text('Paleta seleccionada: ${appData.palette}'),

            // --- Configuracion de la opacidad ---
            Text('Opacidad de fondo'),
            Slider(
              value: appData.backgroundOpacity,
              min: 0.1,
              max: 1.0,
              divisions: 10,
              label: '${(appData.backgroundOpacity * 100).toInt()}%',
              onChanged: (value) {
                context.read<AppData>().setBackgroundOpacity(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
