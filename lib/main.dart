// **
// Created by Mohammed Sadiq on 28/05/20.
// **

import 'package:flutter/material.dart';
import 'package:retro/home_screen.dart';

void main() => runApp(RetroApp());

class RetroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro',
      home: HomeScreen(),
    );
  }
}
