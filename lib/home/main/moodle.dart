import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:regis_flutter/home/moodle/moodleutils.dart';
import 'package:regis_flutter/home/registheme.dart';

import '../../base_components.dart';

class MoodlePage extends StatefulWidget {
  final RegisTheme theme;
  final String token;

  const MoodlePage({Key? key, required this.theme, required this.token}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MoodlePageState();
}

class _MoodlePageState extends State<MoodlePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MoodleClass>>(
      future: getClasses(widget.token),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.toString());
        } else if (snapshot.hasData) {
          return ListView(
              padding: const EdgeInsets.only(top: 5), children: [FractionallySizedBox(widthFactor: 0.95, child: Column(children: getMoodleCards(snapshot.data!, widget.theme)))]);
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}

class MoodleCard extends StatelessWidget {
  final RegisTheme theme;
  final MoodleClass moodleClass;

  const MoodleCard({Key? key, required this.theme, required this.moodleClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.card,
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MoodleSubPage(theme: theme, moodleClass: moodleClass)));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  image: DecorationImage(fit: BoxFit.fitWidth, image: moodleClass.bannerImg),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: FractionallySizedBox(
                widthFactor: .95,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: moodleClass.teacher.avatar,
                      radius: 20,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            text(moodleClass.className, theme.s1Style()),
                            text(moodleClass.teacher.name, theme.subhead1Style()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> getMoodleCards(List<MoodleClass> classes, RegisTheme theme) {
  return classes.map((moodle) => MoodleCard(
    theme: theme,
    moodleClass: moodle,
  )).toList();
}

class MoodleSubPage extends StatefulWidget {
  final RegisTheme theme;
  final MoodleClass moodleClass;

  const MoodleSubPage({Key? key, required this.theme, required this.moodleClass}) : super(key: key);

  @override
  _MoodleSubPageState createState() => _MoodleSubPageState();
}

class _MoodleSubPageState extends State<MoodleSubPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.theme.background,
      appBar: AppBar(
        backgroundColor: RegisColors.regisRed,
        title: Text(widget.moodleClass.className),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {

            },
            icon: CircleAvatar(radius: 16, backgroundImage: widget.moodleClass.teacher.avatar),
          )
        ],
      ),
    );
  }
}
