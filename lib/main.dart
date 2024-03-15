import 'package:flutter/material.dart';
import 'package:trackable/screens/home.dart';
import 'package:trackable/screens/location_teck_new.dart';
import 'package:trackable/screens/location_tracking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LocationTracking(),
    );
  }
}
