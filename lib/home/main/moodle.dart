import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:regis_flutter/home/api/moodleapi.dart';
import 'package:regis_flutter/home/registheme.dart';

import '../../base_components.dart';

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
          return LoadingScreen();
        }
      },
    );
  }
}

class MoodleCard extends StatelessWidget {
  final MoodleClass moodleClass;

  const MoodleCard({Key? key, required this.moodleClass}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MoodleSubPage(moodleClass: moodleClass)));
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 2.2,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                  image: DecorationImage(fit: BoxFit.fitWidth, image: moodleClass.bannerImg.image),
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
                      backgroundImage: moodleClass.teacher.avatar.image,
                      radius: 20,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            text(moodleClass.className, theme.textTheme.headline3!),
                            text(moodleClass.teacher.name, theme.textTheme.subtitle1!),
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

List<Widget> getMoodleCards(List<MoodleClass> classes) {
  return classes.map((moodle) => MoodleCard(
    moodleClass: moodle,
  )).toList();
}

class MoodleSubPage extends StatefulWidget {
  final MoodleClass moodleClass;

  const MoodleSubPage({Key? key, required this.moodleClass}) : super(key: key);

  @override
  _MoodleSubPageState createState() => _MoodleSubPageState();
}

class _MoodleSubPageState extends State<MoodleSubPage> {
  @override
  Widget build(BuildContext context) {
  final RegisTheme theme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RegisColors.regisRed,
        title: Text(widget.moodleClass.className),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {
            },
            icon: CircleAvatar(radius: 16, backgroundImage: widget.moodleClass.teacher.avatar.image),
          )
        ],
      ),
      body: FutureBuilder<Widget>(
        future: getClassContents(widget.moodleClass, context),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return const Text("ERROR");
          } else if(snapshot.hasData) {
            return snapshot.data!;
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}
