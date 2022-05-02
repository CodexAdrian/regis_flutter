import 'dart:ui';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  double currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    tabController.addListener(() {
      if(tabController.indexIsChanging) {
        currentIndex = tabController.index.toDouble();
      }
    });
    return Scaffold(
      bottomNavigationBar: DotsIndicator(
        dotsCount: 3,
        position: currentIndex,
      ),
      body: TabBarView(
        controller: tabController,
        children: const [
          SplashCard(
            title: "Ease of Use",
            description: "Noble Heart is designed to simplify the online experience for you",
          ),
          SplashCard(
            title: "Ease of Use",
            description: "Noble Heart is designed to simplify the online experience for you",
          ),
          SplashCard(
            title: "Ease of Use",
            description: "Noble Heart is designed to simplify the online experience for you",
          ),
        ],
      ),
    );
  }
}

class SplashCard extends StatelessWidget {
  final String title;
  final String description;

  const SplashCard({Key? key, required this.title, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Card(
            color: theme.cardColor,
            child: Center(
              heightFactor: 1.2,
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: SvgPicture.asset("assets/icons/smartphone.svg"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: theme.textTheme.headline1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    description,
                    style: theme.textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
