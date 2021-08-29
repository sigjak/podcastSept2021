import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import '/providers/functions.dart';
import 'package:provider/provider.dart';
import '/services/episodes_service.dart';
import '/services/trend_service.dart';
import 'screens/home.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
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
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => TrendProvider()),
//         ChangeNotifierProvider(create: (_) => FunctionProvider()),
//         ChangeNotifierProvider(create: (_) => EpisodeProvider()),
//       ],
//       child: MyApp(),
//     ),
//   );
// }

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
