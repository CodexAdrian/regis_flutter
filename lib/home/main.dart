import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:regis_flutter/base_components.dart';
import 'package:regis_flutter/home/api/loginapi.dart';
import 'package:regis_flutter/home/main/intranet.dart';
import 'package:regis_flutter/home/main/moodle.dart';
import 'package:regis_flutter/home/pages/schedule.dart';
import 'package:regis_flutter/home/pages/splashpage.dart';
import 'package:regis_flutter/home/registheme.dart';

import 'api/auth.dart';

Future<ByteData> loadAsset() async {
  return await rootBundle.load('assets/avatar.webp');
}

void main() {
  runApp(const RegisApp());
}

class RegisApp extends StatelessWidget {
  const RegisApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ThemeData.dark().colorScheme.copyWith(
                primary: const Color(0xFFd61341),
                background: const Color(0xFF1A1A1A),
              ),
          brightness: Brightness.dark,
          primaryColor: const Color(0xFFd61341),
          cardColor: const Color(0xFF393939),
          fontFamily: 'Sans Serif',
          textTheme: const TextTheme(
            headline1: TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            headline2: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            headline3: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            subtitle1: TextStyle(
              fontSize: 18,
              color: Color(0x88FFFFFF),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      home: FutureBuilder<String>(
        future: getToken(),
        builder: (context, snapshot) {
          if(snapshot.hasError) {
            return SplashPage();
          } else if(snapshot.hasData) {
            String token = snapshot.data ?? "error";
            if(token == "error") return const SplashPage();
            return RegisHomePage();
          } else {
            return const SplashPage();
          }
        },
      ),

        //home: SplashPage()
        //home: RegisHomePage(),
        );
  }
}

class RegisHomePage extends StatefulWidget {
  const RegisHomePage({Key? key}) : super(key: key);

  @override
  State<RegisHomePage> createState() => RegisHomeState();
}

class RegisHomeState extends State<RegisHomePage> {
  bool darkMode = true;
  int currentPage = 0;

  void flipMode() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  void setPage(int page) {
    setState(() {
      currentPage = page;
    });
  }

  var pages = const <Widget>[
    Text("Page 1"),
    MoodlePage(),
    Schedule(),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 5,
          backgroundColor: RegisColors.regisRed,
          title: Image.asset(
            "assets/images/wordmark.png",
            height: 55,
          ),
        ),
        body: Center(child: pages[currentPage]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: RegisColors.regisDarkRed,
          elevation: 0,
          selectedItemColor: theme.textTheme.headline1?.color,
          unselectedItemColor: RegisColors.regisRed,
          onTap: setPage,
          currentIndex: currentPage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Moodle'),
            BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          ],
        ),
      ),
    );
  }
}

class DecorativeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const DecorativeTabBar({Key? key, required this.tabBar, required this.decoration}) : super(key: key);

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [Positioned.fill(child: Container(decoration: decoration)), tabBar]);
  }

  @override
  Size get preferredSize => tabBar.preferredSize;
}
