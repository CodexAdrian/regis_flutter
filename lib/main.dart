import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:regis_flutter/base_components.dart';
import 'package:regis_flutter/home/login/login.dart';
import 'package:regis_flutter/home/login/loginapi.dart';
import 'package:regis_flutter/home/main/intranet.dart';
import 'package:regis_flutter/home/main/moodle.dart';
import 'package:regis_flutter/home/registheme.dart';

import 'home/login/auth.dart';


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
      home: RegisHomePage(title: 'Dashboard',),
      //home: RegisHomePage(title: 'Dashboard'),
    );
  }
}

class RegisHomePage extends StatefulWidget {
  const RegisHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<RegisHomePage> createState() => RegisHomeState();
}

class RegisHomeState extends State<RegisHomePage> {
  bool darkMode = true;

  void flipMode() {
    setState(() {
      darkMode = !darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    RegisTheme theme = darkMode ? darkTheme : lightTheme;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.background,
        appBar: AppBar(
          elevation: 5,
          backgroundColor: RegisColors.regisRed,
          title: Text(
            widget.title,
            style: const TextStyle(color: RegisColors.darkText),
          ),
          actions: <Widget>[
            IconButton(
              color: RegisColors.darkText,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification Center Implementation')));
              },
              icon: const Icon(Icons.notifications_outlined),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {
                flipMode();
              },
              icon: const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://cdn.discordapp.com/attachments/817413688771608587/918182744159297576/1ff374a2b9fd0e41c0a70d9f17f24fd5.webp'),
              ),
            ),
          ],
          bottom: const DecorativeTabBar(
            tabBar: TabBar(
              indicatorColor: RegisColors.selector,
              tabs: [
                Tab(text: 'Intranet'),
                Tab(text: 'Moodle'),
                Tab(text: 'Library'),
              ],
            ),
            decoration: BoxDecoration(
              color: RegisColors.regisDarkRed,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            IntranetPage(theme: theme),
            TokenTest(theme: theme),
            LoadingScreen()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: theme.background,
          elevation: 0,
          selectedItemColor: RegisColors.regisRed,
          unselectedItemColor: theme.font,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.event_note), label: 'Calendar'),
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

class TokenTest extends StatelessWidget {
  final RegisTheme theme;

  const TokenTest({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: tryLogin(username(), password()),
      builder: (content, snapshot) {
        if (snapshot.hasError) {
          return const Text('An Error has Ocurred');
        } else if (snapshot.hasData) {
          return MoodlePage(theme: theme, token: jsonDecode(snapshot.data)['token']);
        } else {
          return LoadingScreen();
        }
      },
    );
  }
}
