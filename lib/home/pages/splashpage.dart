import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/icons/smartphone.svg"),
            CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: 50,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset("assets/seal_small.png"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                  "Noble Heart",
                style: theme.textTheme.headline1
              ),
            ),
          ],
        ),
      ),
    );
  }
}
