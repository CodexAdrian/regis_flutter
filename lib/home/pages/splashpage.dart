import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:regis_flutter/home/main.dart';
import 'package:regis_flutter/home/pages/login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<Widget> imgList = [
    SplashCard(title: "Manage your Profile", description: "Manage your profile and see upcoming events", iconPath: "assets/icons/profile.svg"),
    SplashCard(title: "Speedier Moodle", description: "Quickly view all your moodle classes and assignments", iconPath: "assets/icons/moodle.svg"),
    SplashCard(title: "Waaaaay Nicer Schedule", description: "Finally make your schedule easier to view on a mobile device", iconPath: "assets/icons/schedule.svg"),
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: CarouselSlider(
            items: imgList,
            carouselController: _controller,
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height - 28,
                autoPlay: false,
                enlargeCenterPage: false,
                viewportFraction: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: (Colors.white).withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: theme.primaryColor,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (route) => false,);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sign in", style: theme.textTheme.headline3),
            ),
          ),
        )
      ]),
    );
  }
}

class SplashCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconPath;

  const SplashCard({Key? key, required this.title, required this.description, required this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            heightFactor: 1.2,
            child: SizedBox(
              height: 300,
              width: 300,
              child: SvgPicture.asset(iconPath),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: theme.textTheme.headline1,
                  textAlign: TextAlign.center,
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
          )
        ],
      ),
    );
  }
}
