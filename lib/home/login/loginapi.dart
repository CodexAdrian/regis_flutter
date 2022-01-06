import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

tryLogin(String username, String password) async {
  var url = Uri.parse('https://moodle.regis.org/login/token.php?username=${username}&password=${password}&service=moodle_mobile_app');
  var response = await http.read(url);
  return response;
}

getToken() {
  const storage = FlutterSecureStorage();
  storage.read(key: 'token');
}



