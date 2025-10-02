import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/details_page.dart';

void main() {
  runApp(const SubmissionPertamaApp());
}

class SubmissionPertamaApp extends StatelessWidget {
  const SubmissionPertamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission Pertama',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/details': (context) => const DetailsPage(),
      },
    );
  }
}