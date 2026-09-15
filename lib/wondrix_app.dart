import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'wondrix_palette.dart';
import 'color_vision_controller.dart';
import 'palette_validator_view.dart';
import 'wcag_contrast_view.dart';
import 'accessible_palettes_view.dart';
import 'export_spec_view.dart';

class WondrixApp extends StatelessWidget {
  const WondrixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorVisionController(),
      child: MaterialApp(
        title: 'Wondrix Contrast & CVD',
        theme: WondrixPalette.darkTheme,
        debugShowCheckedModeBanner: false,
        home: const WondrixHomeScaffold(),
      ),
    );
  }
}

class WondrixHomeScaffold extends StatefulWidget {
  const WondrixHomeScaffold({super.key});

  @override
  State<WondrixHomeScaffold> createState() => _WondrixHomeScaffoldState();
}

class _WondrixHomeScaffoldState extends State<WondrixHomeScaffold> {
  int _currentIndex = 0;

  final _titles = ['Palette Validator', 'WCAG Contrast', 'Accessible Palettes', 'Export Specs'];
  final _views = const [
    PaletteValidatorView(),
    WcagContrastView(),
    AccessiblePalettesView(),
    ExportSpecView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        centerTitle: true,
      ),
      body: _views[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.palette_outlined), selectedIcon: Icon(Icons.palette), label: 'Validator'),
          NavigationDestination(icon: Icon(Icons.contrast_outlined), selectedIcon: Icon(Icons.contrast), label: 'Contrast'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Palettes'),
          NavigationDestination(icon: Icon(Icons.code_outlined), selectedIcon: Icon(Icons.code), label: 'Export'),
        ],
      ),
    );
  }
}
