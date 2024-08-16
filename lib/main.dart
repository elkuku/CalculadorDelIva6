import 'package:calculador_del_iva_6/calculador.dart';
import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
);
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.green,
  brightness: Brightness.dark,
);

void main() {
  runApp(
    MaterialApp(
      title: 'Calculador del IVA',
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          foregroundColor: kColorScheme.onPrimaryContainer,
          backgroundColor: kColorScheme.primaryContainer,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
          backgroundColor: kDarkColorScheme.primaryContainer,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const Calculador(title: 'Calculador del IVA'),
    ),
  );
}
