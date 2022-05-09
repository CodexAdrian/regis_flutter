import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const tokenName = "moodleToken";

Future<String> tryLogin(String username, String password) async {
  final url = Uri.https("moodle.regis.org" ,"/login/token.php", {"username": username, "password": password, "service": "moodle_mobile_app"});
  final response = await http.get(url);
  try{
    final String token = jsonDecode(response.body)["token"];
    const storage = FlutterSecureStorage();
    await storage.write(key: tokenName, value: token);
    return token;
  } catch(err) {
    return "error";
  }
}

Future<String> getToken() async {
  const storage = FlutterSecureStorage();
  String token = await storage.read(key: tokenName) ?? "error";
  return token;
}



