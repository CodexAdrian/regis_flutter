import 'package:flutter/material.dart';
import 'package:regis_flutter/home/pages/dashboard.dart';
import 'package:regis_flutter/home/pages/schedule.dart';

import 'moodle.dart';

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
    Dashboard(),
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
          backgroundColor: theme.primaryColor,
          title: Image.asset(
            "assets/images/wordmark.png",
            height: 55,
          ),
        ),
        body: Center(child: pages[currentPage]),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: theme.primaryColor,
          elevation: 0,
          selectedItemColor: Colors.white,
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
