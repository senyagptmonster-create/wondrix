import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum CVDType { normal, protanopia, deuteranopia, tritanopia, achromatopsia }

class ColorVisionController extends ChangeNotifier {
  Color _foreground = const Color(0xFF00FFCC);
  Color _background = const Color(0xFF1E293B);
  CVDType _activeCVD = CVDType.normal;

  ColorVisionController() {
    _loadPrefs();
  }

  Color get foreground => _foreground;
  Color get background => _background;
  CVDType get activeCVD => _activeCVD;

  void setForeground(Color c) {
    _foreground = c;
    notifyListeners();
  }

  void setBackground(Color c) {
    _background = c;
    notifyListeners();
  }

  void setCVD(CVDType cvd) {
    _activeCVD = cvd;
    _savePrefs();
    notifyListeners();
  }

  // Calculate Relative Luminance according to WCAG 2.1
  double _luminance(Color c) {
    double r = c.r;
    double g = c.g;
    double b = c.b;

    r = (r <= 0.03928) ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4).toDouble();
    g = (g <= 0.03928) ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4).toDouble();
    b = (b <= 0.03928) ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4).toDouble();

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double get contrastRatio {
    final l1 = _luminance(_foreground);
    final l2 = _luminance(_background);
    final lighter = max(l1, l2);
    final darker = min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  bool get passesAA => contrastRatio >= 4.5;
  bool get passesAAA => contrastRatio >= 7.0;

  // Simulate color vision deficiency
  Color simulate(Color c, CVDType type) {
    if (type == CVDType.normal) return c;

    final r = (c.r * 255.0).round().clamp(0, 255);
    final g = (c.g * 255.0).round().clamp(0, 255);
    final b = (c.b * 255.0).round().clamp(0, 255);

    if (type == CVDType.achromatopsia) {
      final gray = (0.299 * r + 0.587 * g + 0.114 * b).round().clamp(0, 255);
      return Color.fromARGB(255, gray, gray, gray);
    }

    if (type == CVDType.protanopia) {
      // Red-blind approximation
      final nr = (0.56667 * r + 0.43333 * g).round().clamp(0, 255);
      final ng = (0.55833 * r + 0.44167 * g).round().clamp(0, 255);
      final nb = (0.24167 * g + 0.75833 * b).round().clamp(0, 255);
      return Color.fromARGB(255, nr, ng, nb);
    }

    if (type == CVDType.deuteranopia) {
      // Green-blind approximation
      final nr = (0.625 * r + 0.375 * g).round().clamp(0, 255);
      final ng = (0.70 * r + 0.30 * g).round().clamp(0, 255);
      final nb = (0.30 * g + 0.70 * b).round().clamp(0, 255);
      return Color.fromARGB(255, nr, ng, nb);
    }

    // Tritanopia (Blue-blind)
    final nr = (0.95 * r + 0.05 * g).round().clamp(0, 255);
    final ng = (0.43333 * g + 0.56667 * b).round().clamp(0, 255);
    final nb = (0.475 * g + 0.525 * b).round().clamp(0, 255);
    return Color.fromARGB(255, nr, ng, nb);
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final idx = prefs.getInt('wondrix_cvd') ?? 0;
    _activeCVD = CVDType.values[idx.clamp(0, CVDType.values.length - 1)];
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wondrix_cvd', _activeCVD.index);
  }
}
