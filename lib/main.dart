import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

import '/providers/functions.dart';
import '/services/episodes_service.dart';
import '/services/trend_service.dart';
import '/services/podcast_service.dart';
//import 'screens/home.dart';
import 'screens/my_test.dart';

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
        ChangeNotifierProvider(create: (_) => PodcastProvider()),
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
          '/': (context) => MyTest(),
          //'/': (context) => Home(),
          // Episodes.routeName: (context) => Episodes(Object),
        });
  }
}
