import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../registheme.dart';

class LoginScreen extends StatefulWidget {
  final RegisTheme theme;

  LoginScreen({Key? key, required this.theme}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: Text('test')),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: TextField(
              cursorColor: RegisColors.regisRed,
              style: TextStyle(color: widget.theme.font),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.theme.font)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: RegisColors.regisRed)),
                labelStyle: TextStyle(color: widget.theme.font),
                labelText: 'User Name',
                hintText: 'Enter your Regis username',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: TextField(
              obscureText: true,
              cursorColor: RegisColors.regisRed,
              style: TextStyle(color: widget.theme.font),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.theme.font)),
                focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: RegisColors.regisRed)),
                labelStyle: TextStyle(color: widget.theme.font),
                labelText: 'Password',
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 20,
            ),
          )
        ],
      ),
    );
  }
}
