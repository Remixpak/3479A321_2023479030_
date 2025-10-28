import 'package:flutter/material.dart';

class PixelArt {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final Map<String, dynamic> size;
  final List<String> palette;
  final String gridData;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  PixelArt({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.size,
    required this.palette,
    required this.gridData,
    required this.createdAt,
    required this.lastModifiedAt,
  });
}
