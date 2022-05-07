import 'package:flutter/material.dart';

import '../api/moodleapi.dart';
import 'base_components.dart';

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
                  image: DecorationImage(fit: BoxFit.fitWidth, image: Image.network(moodleClass.bannerImg).image),
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

class MoodleSubPage extends StatelessWidget {
  final MoodleClass moodleClass;

  const MoodleSubPage({Key? key, required this.moodleClass});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text(moodleClass.className),
        actions: [
          IconButton(
            iconSize: 30,
            onPressed: () {},
            icon: CircleAvatar(radius: 16, backgroundImage: moodleClass.teacher.avatar.image),
          )
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getClassContents(moodleClass, context),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("ERROR");
          } else if (snapshot.hasData) {
            return SubpageContents(contents: snapshot.data!);
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}

class SubpageContents extends StatelessWidget {
  final List<dynamic> contents;

  const SubpageContents({Key? key, required this.contents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ListView(
        children: contents.map((tab) {
          List<dynamic> modules = tab['modules'];
          return Column(
            children: [
              TextButton.icon(
                icon: Icon(Icons.folder),
                onPressed: modules.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModulePage(modules: modules, title: tab['name'])),
                        );
                      }
                    : null,
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: Text(
                          tab['name'],
                          style: modules.isNotEmpty ? theme.textTheme.headline3 : theme.textTheme.subtitle1,
                        ),
                      ),
                      if (modules.isNotEmpty)
                        FractionallySizedBox(
                          widthFactor: 1,
                          child: Text(
                            "${modules.length} Items",
                            style: theme.textTheme.subtitle1,
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Divider()
            ],
          );
        }).toList(),
      ),
    );
  }
}

class ModulePage extends StatelessWidget {
  final List<dynamic> modules;
  final String title;

  const ModulePage({Key? key, required this.modules, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.primaryColor,
      ),
      body: ListView(
        children: modules.map(
          (module) {
            return Card(
              child: Text(
                module['name'],
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
