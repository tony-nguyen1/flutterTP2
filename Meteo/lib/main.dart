import 'package:flutter/material.dart';

import 'package:meteo/weather_network.dart'; // For JSON decoding

import 'theme/theme.dart'; // Import du fichier thème

void main() {
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP Example',
      theme: appTheme,
      home: Scaffold(
          appBar: AppBar(
              title: const Text('Météo'),),
          body: const DataFetcher()
      ),
    );
  }
}

class DataFetcher extends StatefulWidget {
  const DataFetcher({super.key});

  @override
  State<DataFetcher> createState() => DataFetcherState('Montpellier');
}


