import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              child: CachedNetworkImage(
                imageUrl: moodleClass.bannerImg,
                imageBuilder: (ctx, imgProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                    image: DecorationImage(
                      image: imgProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
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
                    CachedNetworkImage(
                      imageUrl: moodleClass.teacher.avatar,
                      imageBuilder: (ctx, imageBuilder) => CircleAvatar(
                        radius: 20,
                        backgroundImage: imageBuilder,
                      ),
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

  const MoodleSubPage({Key? key, required this.moodleClass})  : super(key: key);

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
            icon: CachedNetworkImage(
              imageUrl: moodleClass.teacher.avatar,
              imageBuilder: (ctx, imageBuilder) => CircleAvatar(
                radius: 16,
                backgroundImage: imageBuilder,
              ),
            ),
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
            return const LoadingScreen();
          }
        },
      ),
    );
  }
}

class SubpageContents extends StatelessWidget {
  final List<dynamic> contents;

  const SubpageContents({Key? key, required this.contents}) : super(key: key);

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
                icon: const Icon(Icons.folder),
                onPressed: modules.isNotEmpty
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModulePage(modules: modules, title: tab['name'], summary: tab["summary"].toString().isNotEmpty ? tab["summary"] : null)),
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
              const Divider()
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
  final String? summary;

  const ModulePage({Key? key, required this.modules, required this.title, this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var htmlRegex = RegExp(r"<[^>]*>", caseSensitive: false, multiLine: true);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: theme.primaryColor,
      ),
      body: ListView(
        children: [
          if (summary != null)
            Card(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                summary!.replaceAll("</h", "\n</").replaceAll("</p", "\n</").replaceAll(htmlRegex, "").replaceAll("&nbsp;", " "),
                style: theme.textTheme.headline3,
              ),
            )),
          Column(
            children: modules.map(
              (module) {
                if (module["description"] != null) {
                  htmlRegex.allMatches(module["description"]).forEach((element) {
                  });
                }
                var moduleIcon = MoodleType.values.firstWhere((element) => element.toString() == "MoodleType.${module["modname"]}", orElse: () => MoodleType.notype);
                return Column(
                  children: [
                    TextButton.icon(
                      icon: moduleIcon.icon,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (builder) => AlertDialog(
                          title: Text(module["name"]),
                          content: module["description"] != null
                              ? Text(module["description"].toString().replaceAll("</h", "\n</").replaceAll(htmlRegex, "").replaceAll("&nbsp;", " "))
                              : const Text(""),
                          actions: [
                            TextButton(onPressed: () => launchUrl(Uri.parse(module["url"] + "")), child: const Text("Open in Browser")),
                            if(moduleIcon == MoodleType.resource && module["contentsinfo"]["mimetypes"][0] == "application/pdf") ElevatedButton(onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => PDFModulePage(pdfUrl: module["contents"][0]["fileurl"], title: module["name"]),)), child: const Text("Open PDF")),
                          ],
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Text(
                                module['name'],
                                style: modules.isNotEmpty ? theme.textTheme.headline3 : theme.textTheme.subtitle1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider()
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}

class PDFModulePage extends StatelessWidget {
  final String pdfUrl;
  final String title;
  const PDFModulePage({Key? key, required this.pdfUrl, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<PDFDocument>(
        future: getMoodlePdf(pdfUrl),
          builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if(snapshot.hasData) {
          return PDFViewer(
            document: snapshot.data!,
            lazyLoad: false,
            scrollDirection: Axis.vertical,
          );
        }
        return const LoadingScreen();
      }),
    );
  }
}


enum MoodleType {
  forum,
  assign,
  lti,
  resource,
  url,
  label,
  turnitintooltwo,
  folder,
  notype,
}

extension MoodleTypeExtension on MoodleType {
  Icon get icon {
    switch (this) {
      case MoodleType.assign:
        return const Icon(Icons.assignment, color: Colors.orange);
      case MoodleType.forum:
        return const Icon(Icons.forum, color: Colors.blue);
      case MoodleType.lti:
        return const Icon(Icons.extension, color: Colors.green);
      case MoodleType.resource:
        return const Icon(Icons.file_copy, color: Colors.tealAccent);
      case MoodleType.url:
        return const Icon(Icons.link, color: Colors.grey);
      case MoodleType.label:
        return const Icon(Icons.campaign, color: Colors.red);
      case MoodleType.turnitintooltwo:
        return const Icon(Icons.upload, color: Colors.red);
      case MoodleType.folder:
        return const Icon(Icons.folder, color: Colors.lightBlueAccent);
      case MoodleType.notype:
        return const Icon(Icons.image, color: Colors.blueGrey);
      default:
        return const Icon(Icons.image, color: Colors.blueGrey);
    }
  }
}
