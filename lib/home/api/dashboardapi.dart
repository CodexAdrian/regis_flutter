import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:regis_flutter/home/api/loginapi.dart';
import 'package:regis_flutter/home/api/moodleapi.dart';

import '../pages/login.dart';

Future<Set<Teacher>> getTeacherList() async {
  final classList = await getClasses();
  return classList.map((e) => e.teacher).toSet();
}

Future<Teacher> getUserInfo() async {
  final storage = FlutterSecureStorage();
  final token = await getToken();
  String? userInfo;
  final userTimer = await storage.read(key: "timeUserInfoStored");
  if (userTimer != null) {
    if (int.parse(userTimer) - DateTime.now().millisecondsSinceEpoch < 216000000) {
      userInfo = await storage.read(key: "userInfo");
    }
  }
  if (userInfo == null) {
    final teacherQuery = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
      "wstoken": token,
      "wsfunction": "core_webservice_get_site_info",
      "moodlewsrestformat": "json",
    });
    userInfo = await read(teacherQuery);
    storeUserInfo(userInfo);
  }
  Map<String, dynamic> userData = jsonDecode(userInfo);
  String userImg = userData['userpictureurl'] + '&token=$token';
  userImg = userImg.replaceFirst('/pluginfile.php', '/webservice/pluginfile.php');
  Teacher user = Teacher(name: userData['fullname'], avatar: userImg, id: userData['userid'], email: userData['username'] + "@regis.org");
  return user;
}

storeUserInfo(String userInfo) {
  final storage = FlutterSecureStorage();
  storage.write(key: "timeUserInfoStored", value: DateTime.now().millisecondsSinceEpoch.toString());
  storage.write(key: "userInfo", value: userInfo);
}

handleSignOut(BuildContext context) {
  final storage = FlutterSecureStorage();
  storage.deleteAll();
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginPage()), (route) => false,);
}
