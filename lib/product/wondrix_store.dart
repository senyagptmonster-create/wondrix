import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WondrixStore extends ChangeNotifier {
  List<dynamic> palettes = [];

  Future<void> load(String jsonStr) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('wondrix_pals')) {
      palettes = jsonDecode(jsonStr)['palettes'] ?? [];
      await save();
    } else {
      palettes = jsonDecode(prefs.getString('wondrix_pals')!);
    }
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('wondrix_pals', jsonEncode(palettes));
  }
}
