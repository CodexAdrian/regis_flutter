import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:regis_flutter/home/api/loginapi.dart';
import 'package:regis_flutter/home/main/moodle.dart';

import '../registheme.dart';

class MoodleClass {
  Teacher teacher;
  String className;
  String description;
  Image bannerImg;
  int id;

  MoodleClass({required this.teacher, required this.className, required this.description, required this.bannerImg, required this.id});
}

class Teacher {
  String? alias;
  String name;
  Image avatar;
  int id;

  Teacher({required this.name, this.alias, required this.avatar, required this.id});
}

Future<List<MoodleClass>> getClasses() async {
  final token = await getToken();
  final userQueryHttps = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
    "wstoken": token,
    "wsfunction": "core_webservice_get_site_info",
    "moodlewsrestformat": "json",
  });
  String userQuery = await read(userQueryHttps);
  var userId = jsonDecode(userQuery);
  final classesQueryHttps = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
    "wstoken": token,
    "wsfunction": "core_enrol_get_users_courses",
    "userid": userId['userid'].toString(),
    "moodlewsrestformat": "json",
  });
  String classesQuery = await read(classesQueryHttps);
  var userClasses = jsonDecode(classesQuery);
  List<MoodleClass> classes = List.empty(growable: true);

  for (Map<String, dynamic> userClass in userClasses) {
    MoodleClass classFromId = await getClassFromId(userClass['id']);
    classes.add(classFromId);
  }
  //classes.add(await getClassFromId(1125, token));
  return classes;
}

Future<MoodleClass> getClassFromId(int id) async {
  final token = await getToken();
  final moodleClassQuery = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
    "wstoken": token,
    "wsfunction": "core_course_get_courses_by_field",
    "field": "id",
    "value": id.toString(),
    "moodlewsrestformat": "json",
  });
  String moodleClass = await read(moodleClassQuery);
  Map<String, dynamic> classInstance = jsonDecode(moodleClass)['courses'][0];
  int teacherID = classInstance['contacts'][0]['id'];
  final teacherQuery = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
    "wstoken": token,
    "wsfunction": "core_user_get_users_by_field",
    "field": "id",
    "values[]": teacherID.toString(),
    "moodlewsrestformat": "json",
  });
  String teacherRequest = await read(teacherQuery);
  Map<String, dynamic> teacherData = jsonDecode(teacherRequest)[0];
  String teacherImg = teacherData['profileimageurl'] + '&token=$token';
  teacherImg = teacherImg.replaceFirst('/pluginfile.php', '/webservice/pluginfile.php');
  Teacher teacher = Teacher(name: teacherData['fullname'], avatar: Image.network(teacherImg), id: teacherID);
  String? imgBanner;
  try {
    imgBanner = classInstance['overviewfiles'][0]['fileurl'] + '?token=$token';
  } catch (e) {
    switch (classInstance['categoryname']) {
      case 'Arts':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921059436028657785/unknown.png';
          break;
        }
      case 'Extracurriculars':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921058590725406780/unknown.png';
          break;
        }
      case 'Theology':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064553247277066/unknown.png';
          break;
        }
      case 'Computer Science':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064752153788416/unknown.png';
          break;
        }
      case 'English':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064943967682580/unknown.png';
          break;
        }
      case 'Guidance':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/730599217491476593/921066091994812506/Screen_Shot_2021-12-16_at_10.47.39_AM.png';
          break;
        }
      case 'Interdisciplinary':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921066885645238332/unknown.png';
          break;
        }
      case 'Mathematics':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921067836129021992/unknown.png';
          break;
        }
      case 'Physical Education':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/910023440948420608/unknown.png';
          break;
        }
      case 'History':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921070717498425444/unknown.png';
          break;
        }
      case 'Advisement Groups':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921070075707031602/unknown.png';
          break;
        }
      case 'Miscellaneous':
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921069215803379782/unknown.png';
          break;
        }
      default:
        {
          imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921052226842136606/unknown.png';
        }
    }
  }
  return MoodleClass(teacher: teacher, className: classInstance['displayname'], description: classInstance['displayname'], bannerImg: Image.network(imgBanner!), id: id);
}

Future<Widget> getClassContents(MoodleClass moodleClass, BuildContext context) async {
  var theme = Theme.of(context);
  final token = await getToken();
  String classContentString = await getStoredClass(moodleClass);

  if (classContentString == "error") {
    final classContentQuery = Uri.https("moodle.regis.org", "/webservice/rest/server.php", {
      "wstoken": token,
      "wsfunction": "core_course_get_contents",
      "courseid": moodleClass.id.toString(),
      "moodlewsrestformat": "json",
    });
    classContentString = await read(classContentQuery);
    storeClassContent(classContentString, moodleClass);
  }

  List<dynamic> classContent = jsonDecode(classContentString);
  return ListView(
    children: classContent.map((tab) {
      List<dynamic> modules = tab['modules'];
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Text(
                  tab['name'],
                  style: theme.textTheme.headline3,
                ),
              ),
              if (modules.isNotEmpty)
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Text(
                    "${modules.length} Items",
                    style: theme.textTheme.subtitle1,
                  ),
                )
            ],
          ),
        ),
      );
    }).toList(),
  );
}

Future<String> getStoredClass(MoodleClass moodleClass) async {
  const storage = FlutterSecureStorage();
  String? timeStamp = await storage.read(key: "timeStampOf${moodleClass.id}");
  bool getFromStorage = false;

  if (timeStamp != null) {
    var timePassed = DateTime.now().microsecondsSinceEpoch - int.parse(timeStamp);
    if (timePassed < 21600000) {
      getFromStorage = true;
    }
  }

  if (getFromStorage) {
    return await storage.read(key: "contentOf${moodleClass.id}") ?? "error";
  }

  return "error";
}

void storeClassContent(String content, MoodleClass moodleClass) {
  const storage = FlutterSecureStorage();
  storage.write(key: "timeStampOf${moodleClass.id}", value: DateTime.now().millisecondsSinceEpoch.toString());
  storage.write(key: "contentOf${moodleClass.id}", value: content);
}
