import 'package:flutter/material.dart';
import 'package:bankai_streaming/pages/mockup_carousel_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bankai Streaming',
      theme: ThemeData.dark(useMaterial3: true),
      home: const MockupCarouselPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
