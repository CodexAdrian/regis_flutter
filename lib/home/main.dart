import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:regis_flutter/home/api/loginapi.dart';
import 'package:regis_flutter/home/pages/homepage.dart';
import 'package:regis_flutter/home/pages/splashpage.dart';

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
              secondary: const Color(0xFFbb0e35),
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
          if (snapshot.hasError) {
            return const SplashPage();
          } else if (snapshot.hasData) {
            String token = snapshot.data ?? "error";
            if (token == "error") return const SplashPage();
            return const RegisHomePage();
          } else {
            return const SplashPage();
          }
        },
      ),
    );
  }
}
