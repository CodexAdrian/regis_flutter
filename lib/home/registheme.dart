import 'dart:ui';

import 'package:flutter/cupertino.dart';

class RegisColors {
  static const Color lightBg = Color(0xFFF9EDED);
  static const Color lightFont = Color(0xFFFFFFFF);
  static const Color lightSubFont = Color(0xFFAEA8CE);
  static const Color lightCard = Color(0xFFEEDEDE);
  static const Color darkBg = Color(0xFF20182D);
  static const Color darkFont = Color(0xFF2D1818);
  static const Color darkSubFont = Color(0xFF714F4F);
  static const Color regisRed = Color(0xFFd61341);
  static const Color selector = Color(0xffdc6a6a);
  static const Color regisDarkRed = Color(0xFFbb0e35);
  static const Color darkCard = Color(0xFF343046);
  static const Color darkSubCard = Color(0xFF575271);
  static const Color lightSubCard = Color(0xFFEACACA);
}

class RegisTheme {
  final Color background;
  final Color font;
  final Color subFont;
  final Color card;
  final Color subCard;

  const RegisTheme({
    required this.background,
    required this.font,
    required this.subFont,
    required this.card,
    required this.subCard
  });

  TextStyle h1Style() {
    return TextStyle(
      color: font,
      fontSize: 22,
      //fontWeight: FontWeight.bold,
    );
  }
  TextStyle s1Style() {
    return TextStyle(
      color: font,
      fontSize: 22,
    );
  }
  TextStyle h2Style() {
    return TextStyle(
      color: font,
      fontSize: 18,
      //fontWeight: FontWeight.bold,
      //decoration: TextDecoration.underline,
    );
  }
  TextStyle h3Style() {
    return TextStyle(
      color: font,
      fontSize: 16,
    );
  }

  TextStyle subcardStyle() {
    return TextStyle(
      color: font,
      fontSize: 14,
    );
  }

  TextStyle subhead1Style() {
    return TextStyle(
      color: subFont,
      fontSize: 12,
    );
  }
}

const RegisTheme darkTheme = RegisTheme(
  background: RegisColors.darkBg,
  font: RegisColors.lightFont,
  subFont: RegisColors.lightSubFont,
  card: RegisColors.darkCard,
  subCard: RegisColors.darkSubCard

);
const RegisTheme lightTheme = RegisTheme(
  background: RegisColors.lightBg,
  font: RegisColors.darkFont,
  subFont: RegisColors.darkSubFont,
  card: RegisColors.lightCard,
  subCard: RegisColors.lightSubCard
);
