import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../registheme.dart';

class SubcardWithIcon extends StatelessWidget {
  final RegisTheme theme;
  final String text;
  final IconData icon;
  final Color color;

  const SubcardWithIcon({Key? key, required this.theme, required this.text, required this.color, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 1,
        color: theme.subCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              padding: const EdgeInsets.all(2),
              child: Icon(icon, color: RegisColors.lightBg, size: 24),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 4,
                right: 8,
              ),
              child: Text(text, style: theme.subCardStyle()),
            ),
          ],
        ),
      ),
    );
  }
}

class Subcard extends StatelessWidget {
  final RegisTheme theme;
  final String text;

  const Subcard({Key? key, required this.theme, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 1,
        color: theme.subCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
            top: 5,
            bottom: 5,
            right: 10,
          ),
          child: Text(text, style: theme.subCardStyle()),
        ),
      ),
    );
  }
}

class DropdownSubcard extends StatefulWidget {
  final RegisTheme theme;
  final String defaultVal;
  final List<String> values;

  const DropdownSubcard({Key? key, required this.theme, required this.defaultVal, required this.values}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DropdownSubcardState();
}

class DropdownSubcardState extends State<DropdownSubcard> {
  String value = '';

  void updateVal(String newVal) {}

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          value = newValue!;
        });
      },
      items: <String>['One', 'Two', 'Free', 'Four'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class TitleSubcard extends StatelessWidget {
  final String text;
  final Color fontColor;
  final Color color;

  const TitleSubcard({Key? key, required this.text, this.fontColor = RegisColors.darkText, this.color = RegisColors.regisRed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Card(
        elevation: 1,
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
        child: Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: fontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget text(String string, TextStyle style) {
  return FractionallySizedBox(
    widthFactor: 1,
    child: Text(string, textAlign: TextAlign.left, style: style),
  );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints.expand(width: 40, height: 40),
        child: const CircularProgressIndicator(color: RegisColors.regisRed, strokeWidth: 3),
      ),
    );
  }
}

class RegisCard extends StatelessWidget {
  final String? cardImg;
  final String? avatarImg;
  final String title;
  final String? subtitle;
  final Map<Widget, Function()>? actions;

  const RegisCard({Key? key, this.cardImg, this.avatarImg, required this.title, this.subtitle, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      elevation: 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (cardImg != null)
            AspectRatio(
              aspectRatio: 2.2,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
                ),
                child: CachedNetworkImage(imageUrl: cardImg!),
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
                  if (avatarImg != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: CachedNetworkImage(
                        imageUrl: avatarImg!,
                        imageBuilder: (ctx, imageBuilder) => CircleAvatar(
                          radius: 24,
                          backgroundImage: imageBuilder,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          text(title, theme.textTheme.headline3!),
                          if (subtitle != null) text(subtitle!, theme.textTheme.subtitle1!),
                          Row(
                            children: (actions?.entries.map(
                                      (e) => ElevatedButton(
                                        onPressed: e.value,
                                        child: e.key,
                                      ),
                                    ) ??
                                    List.empty())
                                .toList(),
                          )
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
    );
  }
}
