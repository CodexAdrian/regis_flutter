import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const tokenName = "moodleToken";

Future<String> tryLogin(String username, String password) async {
  try{
    final url = Uri.parse('https://moodle.regis.org/login/token.php?username=$username&password=$password&service=moodle_mobile_app');
    final response = await http.read(url);
    final token = jsonDecode(response)['token'];
    const storage = FlutterSecureStorage();
    storage.write(key: tokenName, value: token);
    return token;
  } on Exception catch(err) {
    return "An Error has Occurred";
  }
}

Future<String> getToken() async {
  const storage = FlutterSecureStorage();
  String token = await storage.read(key: tokenName) ?? "error";
  print(token);
  return token;
}



