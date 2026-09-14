import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens.dart';
import 'wondrix_store.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WondrixStore(),
      child: MaterialApp(
        title: 'Wondrix',
        home: const WondrixHome(),
      ),
    );
  }
}
