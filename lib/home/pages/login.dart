import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:regis_flutter/home/api/loginapi.dart';
import 'package:regis_flutter/home/main.dart';
import 'package:regis_flutter/home/pages/splashpage.dart';

import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void showLoginError(BuildContext context) {
    var theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Login Error",
          style: theme.textTheme.headline3,
        ),
        content: Text(
          "The username or password you submitted is not valid. Please try again.",
          style: theme.textTheme.bodySmall,
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context, 'OK'), child: const Text("OK"))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String username = "";
    String password = "";
    var theme = Theme.of(context);
    return Scaffold(
      body: ListView(
        children: [
          Center(
            heightFactor: 1.2,
            child: SizedBox(
              height: 300,
              width: 300,
              child: SvgPicture.asset("assets/icons/login.svg"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Login with Regis Moodle",
                    style: theme.textTheme.headline2,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        enableSuggestions: false,
                        autocorrect: false,
                        onChanged: (newValue) => username = newValue,
                        onSaved: (newValue) => username = newValue!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please input your username.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                          hintText: "Username",
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (newValue) => password = newValue,
                        onSaved: (newValue) => password = newValue!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please input your password.";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide()),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.primaryColor)),
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                      ),
                    ),
                  ]),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Logging you in ...', style: theme.textTheme.bodySmall),
                          backgroundColor: theme.cardColor,
                        ),
                      );
                      tryLogin(username, password).then(
                        (value) => {
                          if (value != "error")
                            {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => RegisHomePage())),
                            }
                          else
                            {
                              showLoginError(context),
                            }
                        },
                        onError: (e) => {
                          showLoginError(context),
                        },
                      );
                    }
                  },
                  child: Text(
                    "Log in",
                    style: theme.textTheme.headline3,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
