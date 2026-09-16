import 'dart:math';
import 'package:flutter/material.dart';
import 'theme/wondrix_theme.dart';
import 'painters/cvd_spectrum_painter.dart';

class WondrixApp extends StatefulWidget {
  const WondrixApp({super.key});

  @override
  State<WondrixApp> createState() => _WondrixAppState();
}

class _WondrixAppState extends State<WondrixApp> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String _selectedMode = 'Normal';
  final List<String> _modes = ['Normal', 'Protanopia', 'Deuteranopia', 'Tritanopia'];
  Color _testColor = const Color(0xFFEF4444); // Sample Crimson

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wondrix Color Lab',
      debugShowCheckedModeBanner: false,
      theme: WondrixTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'WONDRIX COLOR LAB',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: WondrixTheme.ink,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  children: [
                    _buildSimulatorPage(),
                    _buildContrastGaugePage(),
                    _buildAccessiblePresetsPage(),
                    _buildSpecExportPage(),
                  ],
                ),
              ),
              // Dots indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (i) {
                    final isSel = _currentPage == i;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: isSel ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSel ? WondrixTheme.accent : WondrixTheme.edge,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimulatorPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Visual Color Wheel Painter
          Center(
            child: SizedBox(
              width: 220,
              height: 220,
              child: CustomPaint(
                painter: ColorVisionDeficiencyPainter(
                  cvdMode: _selectedMode,
                  sampleColor: _testColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Active Simulation: $_selectedMode',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: WondrixTheme.ink),
          ),
          const SizedBox(height: 12),
          // Mode filter selector chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _modes.map((m) {
              final isSel = _selectedMode == m;
              return ChoiceChip(
                label: Text(m, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSel ? Colors.white : WondrixTheme.ink)),
                selected: isSel,
                selectedColor: WondrixTheme.accent,
                backgroundColor: WondrixTheme.surface,
                onSelected: (_) => setState(() => _selectedMode = m),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Test swatches
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Target Swatch:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Color(0xFFEF4444),
                      const Color(0xFF10B981),
                      const Color(0xFF3B82F6),
                      const Color(0xFFF59E0B),
                      const Color(0xFF8B5CF6),
                    ].map((c) {
                      final isSel = _testColor == c;
                      return GestureDetector(
                        onTap: () => setState(() => _testColor = c),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: c,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSel ? WondrixTheme.ink : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContrastGaugePage() {
    // WCAG relative luminance contrast computation
    final lum1 = _luminance(_testColor);
    const lum2 = 1.0; // White surface
    final ratio = (max(lum1, lum2) + 0.05) / (min(lum1, lum2) + 0.05);

    final passAA = ratio >= 4.5;
    final passAAA = ratio >= 7.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    '${ratio.toStringAsFixed(2)} : 1',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: passAA ? WondrixTheme.success : WondrixTheme.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Contrast Ratio Against White', style: TextStyle(fontSize: 13, color: WondrixTheme.muted)),
                  const Divider(height: 28, color: WondrixTheme.edge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildWcagBadge('Normal Text (AA)', passAA),
                      _buildWcagBadge('Large Text (AAA)', passAAA),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Sample preview box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _testColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accessible Contrast Sample',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Ensure high perceptual difference across all visual modalities, helping individuals with protanopia, deuteranopia, and tritanopia clearly distinguish key actions.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _luminance(Color c) {
    double f(double v) => v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * f(c.r) + 0.7152 * f(c.g) + 0.0722 * f(c.b);
  }

  Widget _buildWcagBadge(String label, bool pass) {
    return Column(
      children: [
        Icon(pass ? Icons.check_circle_rounded : Icons.cancel_rounded, color: pass ? WondrixTheme.success : Colors.red),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(pass ? 'PASSED' : 'FAIL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: pass ? WondrixTheme.success : Colors.red)),
      ],
    );
  }

  Widget _buildAccessiblePresetsPage() {
    final palettes = [
      {
        'name': 'Universal High Contrast',
        'colors': [const Color(0xFF004949), const Color(0xFF009292), const Color(0xFFFF6DB6), const Color(0xFFFFB677), const Color(0xFF490092)],
        'desc': 'Optimized for all 3 color deficiencies plus low vision.',
      },
      {
        'name': 'Wong Safe Categorical',
        'colors': [const Color(0xFFE69F00), const Color(0xFF56B4E9), const Color(0xFF009E73), const Color(0xFFF0E442), const Color(0xFF0072B2)],
        'desc': 'The gold-standard Bang Wong accessible scientific palette.',
      },
      {
        'name': 'Tol Muted Tones',
        'colors': [const Color(0xFF332288), const Color(0xFF88CCEE), const Color(0xFF44AA99), const Color(0xFF117733), const Color(0xFF999933)],
        'desc': 'Paul Tol qualitative palette with distinct perceptual steps.',
      },
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: palettes.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final p = palettes[i];
        final colors = p['colors'] as List<Color>;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                Row(
                  children: colors.map((c) {
                    return Expanded(
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(6)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Text(p['desc'] as String, style: const TextStyle(fontSize: 12, color: WondrixTheme.muted)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpecExportPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Accessible CSS Tokens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 12),
              SelectableText(
                '/* WCAG 2.1 AA Compliant Theme */\n'
                ':root {\n'
                '  --color-primary: #4F46E5;\n'
                '  --color-protan-safe: #009E73;\n'
                '  --color-deuteran-safe: #D55E00;\n'
                '  --color-tritan-safe: #CC79A7;\n'
                '  --color-contrast-text: #1E1B4B;\n'
                '  --min-contrast-ratio: 4.5;\n'
                '}',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: WondrixTheme.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
