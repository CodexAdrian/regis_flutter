import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regis_flutter/home/registheme.dart';

class LibraryPage extends StatefulWidget {
  final RegisTheme theme;

  const LibraryPage({Key? key, required this.theme}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LibraryState();
}

class LibraryState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    double margin = MediaQuery.of(context).size.width * .95 * 0.04;
    RegisTheme theme = widget.theme;
    return ListView(
      padding: const EdgeInsets.only(top: 5),
      children: [
        FractionallySizedBox(
          widthFactor: 0.95,
          child: Column(
            children: [],
          ),
        ),
      ],
    );
  }

  Widget databaseCard(RegisTheme theme, LibraryDatabase database, double margin) {
    return Card(
      color: theme.card,
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 2.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(fit: BoxFit.fitWidth, image: database.banner),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(margin),
            child: Text(
              database.name,
              textAlign: TextAlign.left,
              style: theme.h1Style(),
            ),
          ),
        ],
      ),
    );
  }
}

class LibraryDatabase {
  NetworkImage banner;
  String name;
  String description;
  String userName;
  String password;
  Url databaseURL;

  LibraryDatabase(this.banner, this.name, this.description, this.userName, this.password, this.databaseURL);
}
