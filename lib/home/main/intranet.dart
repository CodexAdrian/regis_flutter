import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:regis_flutter/base_components.dart';
import 'package:regis_flutter/home/registheme.dart';

class IntranetPage extends StatefulWidget {
  final RegisTheme theme;

  const IntranetPage({Key? key, required this.theme}) : super(key: key);

  @override
  State<StatefulWidget> createState() => IntranetState();
}

const frBenderImg = NetworkImage(
    'https://news.regis.org/wp-content/uploads/2021/12/Tree-Lighting-11.jpg');

class IntranetState extends State<IntranetPage> {
  @override
  Widget build(BuildContext context) {
    RegisTheme theme = widget.theme;
    return ListView(
      padding: const EdgeInsets.only(top: 5),
      children: [
        FractionallySizedBox(
          widthFactor: 0.95,
          child: Column(
            children: [
              newsCard(theme),
              spiritCard(theme, context),
              scheduleCard(theme, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget newsCard(RegisTheme theme) {
    return RegisCard(
      title: 'Latest News',
      theme: theme,
      cardImg: frBenderImg,
      subtitle: 'Christmas Tree Lighting Rings In Advent at Regis',
    );
  }

  Widget spiritCard(RegisTheme theme, BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * .95;
    double cardMarginPercent = 0.04;
    double stampSpacingPercent = 0.004;
    double stampSize = cardWidth * (1 - 2 * cardMarginPercent) * (.2 - 2 * stampSpacingPercent);
    return Card(
      color: theme.card,
      elevation: 1,
      child: Container(
        margin: EdgeInsets.all(cardWidth * cardMarginPercent),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            text('Digital Spirit Card', theme.h1Style()),
            Row(
              children: List.generate(
                5,
                (index) => Expanded(
                  child: Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(bottom: 5, top: 5),
                      shape: const CircleBorder(),
                      borderOnForeground: true,
                      color: RegisColors.regisRed,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.sports_baseball_outlined,
                          size: stampSize * .8,
                          color: RegisColors.darkText,
                        ),
                      )),
                ),
              ),
            ),
            Divider(color: theme.subFont, height: 10),
            //text('Upcoming Events:', theme.h2Style()),
            SubcardWithIcon(theme: theme, text: 'Romeo & Juliet @ Regis - 3:30 PM', color: RegisColors.regisRed, icon: Icons.theater_comedy_outlined),
            SubcardWithIcon(theme: theme, text: 'Basketball Game @ Van Nest... 7:30 PM', color: RegisColors.regisRed, icon: Icons.sports_basketball_outlined)
          ],
        ),
      ),
    );
  }

  Widget scheduleCard(RegisTheme theme, BuildContext context) {
    return Card(
      color: theme.card,
      elevation: 1,
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(MediaQuery.of(context).size.width * .95 * 0.04),
          child: Column(
            children: [
              Row(
                children: [
                  const TitleSubcard(text: 'H Day'),
                  Subcard(theme: theme, text: 'Adrian Ortiz Villago...'),
                  Subcard(theme: theme, text: 'Today'),
                ],
              )
            ],
          )),
    );
  }
}
