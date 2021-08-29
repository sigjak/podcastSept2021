import 'package:flutter/material.dart';
import '/providers/functions.dart';
import 'package:provider/provider.dart';
import '/services/episodes_service.dart';
import '/services/trend_service.dart';
import 'screens/home.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TrendProvider()),
        ChangeNotifierProvider(create: (_) => FunctionProvider()),
        ChangeNotifierProvider(create: (_) => EpisodeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey,
          accentColor: Colors.amber.shade600,
        ),
        routes: {
          '/': (context) => Home(),
          // Episodes.routeName: (context) => Episodes(Object),
        });
  }
}
