import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import 'wondrix_store.dart';

class WondrixHome extends StatelessWidget {
  const WondrixHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wondrix', style: AppTheme.display(context))),
      body: PageView(
        children: const [
          PaletteValidatorScreen(),
          WCAGContrastScreen(),
          AccessibleColorsScreen(),
          ExportSpecsScreen(),
        ],
      ),
    );
  }
}

class PaletteValidatorScreen extends StatelessWidget {
  const PaletteValidatorScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Palette Validator', style: AppTheme.display(context)));
}

class WCAGContrastScreen extends StatelessWidget {
  const WCAGContrastScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('WCAG Contrast Gauge', style: AppTheme.display(context)));
}

class AccessibleColorsScreen extends StatelessWidget {
  const AccessibleColorsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final store = context.watch<WondrixStore>();
    return ListView.builder(
      itemCount: store.palettes.length,
      itemBuilder: (context, index) {
        final pal = store.palettes[index];
        return ListTile(
          title: Text(pal['name'], style: AppTheme.text(context)),
        );
      },
    );
  }
}

class ExportSpecsScreen extends StatelessWidget {
  const ExportSpecsScreen({super.key});
  @override
  Widget build(BuildContext context) => Center(child: Text('Export Specs', style: AppTheme.display(context)));
}
