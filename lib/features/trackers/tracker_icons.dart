import 'package:flutter/material.dart';

/// Icons a tracker can use, by stored key.
const trackerIcons = <String, IconData>{
  'star': Icons.star_outline,
  'water': Icons.water_drop_outlined,
  'run': Icons.directions_run,
  'workout': Icons.fitness_center,
  'meditate': Icons.self_improvement,
  'book': Icons.menu_book_outlined,
  'music': Icons.music_note,
  'code': Icons.code,
  'brush': Icons.brush_outlined,
  'food': Icons.restaurant_outlined,
  'sleep': Icons.bedtime_outlined,
  'pill': Icons.medication_outlined,
  'clean': Icons.cleaning_services_outlined,
  'plant': Icons.local_florist_outlined,
  'language': Icons.translate,
  'heart': Icons.favorite_border,
};

IconData trackerIcon(String key) => trackerIcons[key] ?? Icons.star_outline;
