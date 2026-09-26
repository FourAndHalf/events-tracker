import 'package:flutter/material.dart';

const _seed = Color(0xFF2F6F5E);

ThemeData _build(Brightness b) => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: b),
    );

final lightTheme = _build(Brightness.light);
final darkTheme = _build(Brightness.dark);
