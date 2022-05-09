import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regis_flutter/home/api/moodleapi.dart';

import '../components/base_components.dart';
import '../components/moodle_components.dart';

class MoodlePage extends StatefulWidget {

  const MoodlePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoodlePageState();
}

class _MoodlePageState extends State<MoodlePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoodleClass>>(
      future: getClasses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.toString());
        } else if (snapshot.hasData) {
          return ListView(
              padding: const EdgeInsets.only(top: 5), children: [FractionallySizedBox(widthFactor: 0.95, child: Column(children: getMoodleCards(snapshot.data!)))]);
        } else {
          return const LoadingScreen();
        }
      },
    );
  }
}

List<Widget> getMoodleCards(List<MoodleClass> classes) {
  return classes.map((moodle) => MoodleCard(
    moodleClass: moodle,
  )).toList();
}