import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/podcast_service.dart';

class MyTest extends StatefulWidget {
  const MyTest({Key? key}) : super(key: key);

  @override
  _MyTestState createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  @override
  Widget build(BuildContext context) {
    var pod = context.read<PodcastProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Title'),
      ),
      body: Center(
          child: Container(
        child: ElevatedButton(
            onPressed: () async {
              await pod.getPodcasts('fresh+air');
            },
            child: Text('Podcast')),
      )),
    );
  }
}
