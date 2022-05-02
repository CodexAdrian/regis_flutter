import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:regis_flutter/home/main/moodle.dart';

import '../registheme.dart';

class MoodleClass {
  Teacher teacher;
  String className;
  String description;
  NetworkImage bannerImg;
  int id;

  MoodleClass(this.teacher, this.className, this.description, this.bannerImg, this.id);
}

class Teacher {
  String name;
  String alias;
  NetworkImage avatar;
  int id;

  Teacher(this.name, this.alias, this.avatar, this.id);
}

Future<List<MoodleClass>> getClasses(String token) async {
  String userQuery = await read(Uri.parse('https://moodle.regis.org/webservice/rest/server.php?wstoken=$token&wsfunction=core_webservice_get_site_info&moodlewsrestformat=json'));
  Map<String, dynamic> userInfo = jsonDecode(userQuery);
  String classesQuery = await read(
      Uri.parse('https://moodle.regis.org/webservice/rest/server.php?wstoken=$token&wsfunction=core_enrol_get_users_courses&userid=${userInfo["userid"]}&moodlewsrestformat=json'));
  var userClasses = jsonDecode(classesQuery);
  List<MoodleClass> classes = List.empty(growable: true);

  for(Map<String, dynamic> userClass in userClasses) {
    MoodleClass classFromId = await getClassFromId(userClass['id'], token);
    classes.add(classFromId);
  }
  //classes.add(await getClassFromId(1125, token));
  return classes;
}

Future<MoodleClass> getClassFromId(int id, String token) async {
  String moodleClass = await read(
      Uri.parse('https://moodle.regis.org/webservice/rest/server.php?wstoken=$token&wsfunction=core_course_get_courses_by_field&field=id&value=$id&moodlewsrestformat=json'));
  Map<String, dynamic> classInstance = jsonDecode(moodleClass)['courses'][0];
  int teacherID = classInstance['contacts'][0]['id'];
  String teacherQuery = await read(
      Uri.parse('https://moodle.regis.org/webservice/rest/server.php?wstoken=$token&wsfunction=core_user_get_users_by_field&field=id&values[]=$teacherID&moodlewsrestformat=json'));
  Map<String, dynamic> teacherData = jsonDecode(teacherQuery)[0];
  String teacherImg = teacherData['profileimageurl'] + '&token=$token';
  teacherImg = teacherImg.replaceFirst('/pluginfile.php', '/webservice/pluginfile.php');
  Teacher teacher = Teacher(teacherData['fullname'], teacherData['fullname'], NetworkImage(teacherImg), teacherID);
  String? imgBanner;
  try{
    imgBanner = classInstance['overviewfiles'][0]['fileurl'] + '?token=$token';
  } catch (e) {
    switch (classInstance['categoryname']) {
      case 'Arts': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921059436028657785/unknown.png';
        break;
      }
      case 'Extracurriculars': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921058590725406780/unknown.png';
        break;
      }
      case 'Theology': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064553247277066/unknown.png';
        break;
      }
      case 'Computer Science': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064752153788416/unknown.png';
        break;
      }
      case 'English': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921064943967682580/unknown.png';
        break;
      }
      case 'Guidance': {
        imgBanner = 'https://cdn.discordapp.com/attachments/730599217491476593/921066091994812506/Screen_Shot_2021-12-16_at_10.47.39_AM.png';
        break;
      }
      case 'Interdisciplinary': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921066885645238332/unknown.png';
        break;
      }
      case 'Mathematics': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921067836129021992/unknown.png';
        break;
      }
      case 'Physical Education': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/910023440948420608/unknown.png';
        break;
      }
      case 'History': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921070717498425444/unknown.png';
        break;
      }
      case 'Advisement Groups': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921070075707031602/unknown.png';
        break;
      }
      case 'Miscellaneous': {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921069215803379782/unknown.png';
        break;
      }
      default: {
        imgBanner = 'https://cdn.discordapp.com/attachments/817413688771608587/921052226842136606/unknown.png';
      }
    }
  }
  return MoodleClass(teacher, classInstance['displayname'], classInstance['displayname'], NetworkImage(imgBanner!), id);
}
