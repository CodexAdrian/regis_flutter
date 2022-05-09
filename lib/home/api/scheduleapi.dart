import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiver/collection.dart';

class ScheduleDay {
  final LetterDay letterDay;
  final DateTime day;
  final List<ScheduleBlock> blocks;

  ScheduleDay({required this.letterDay, required this.day, required this.blocks});
}

class ScheduleBlock {
  final String location;
  final String name;
  final TimeOfDay? timeStart;
  final TimeOfDay? timeEnd;
  final String? letterDay;

  ScheduleBlock({required this.location, required this.name, this.timeStart, required this.timeEnd, this.letterDay});

  int getModLength() {
    return ((timeEnd!.hour * 60 + timeEnd!.minute) - (timeStart!.hour * 60 + timeStart!.minute)) ~/ 15;
  }

  int getModStart() {
    return ((timeStart!.hour * 60 + timeStart!.minute) - 510) ~/ 15;
  }
}

enum LetterDay {
  A, B, C, D, E, F, G, H
}

extension LetterDayExtension on LetterDay {
  String toShortString() {
    return toString().split(".").last;
  }
}

Future<List<ScheduleDay>> getScheduleDays() async {
  final data = await rootBundle.loadString('assets/schedule.csv');
  final stuff = const CsvToListConverter(fieldDelimiter: ",", eol: "\\n").convert(data).toList();
  stuff.removeAt(0);
  stuff.removeLast();
  final classDays = ListMultimap<String, ScheduleBlock>();
  for (List<dynamic> e in stuff) {
    final timeStartValues = e[1].toString().split(RegExp(r"\s|:"));
    TimeOfDay? startTime;
    try {
      startTime = TimeOfDay(hour: (int.parse(timeStartValues[0]) % 12) + (timeStartValues[2] == "PM" ? 12 : 0), minute: int.parse(timeStartValues[1]));
    } catch(error) {
      startTime = null;
    }
    final timeEndValues = e[3].toString().split(RegExp(r"\s|:"));
    TimeOfDay? endTime;
    try {
      endTime = TimeOfDay(hour: (int.parse(timeEndValues[0]) % 12) + (timeEndValues[2] == "PM" ? 12 : 0), minute: int.parse(timeEndValues[1]));
    } catch(error) {
      endTime = null;
    }
    classDays.add(e[0], ScheduleBlock(location: e[5], name: e[4], timeStart: startTime, timeEnd: endTime, letterDay: e[6]=="1" || e[6]==1 ? e[4] : null));
  }
  List<ScheduleDay> scheduleDays = List.empty(growable: true);
  classDays.asMap().forEach((dayString, blocks) {
    final letterDayBlock = blocks.last;
    String letterDayString = letterDayBlock.letterDay![0];
    blocks.removeLast();
    LetterDay letterDay = LetterDay.values.firstWhere((element) => element.toString() == "LetterDay.$letterDayString");
    final dayDetails = dayString.split("/");
    final day = DateTime(int.parse("20${dayDetails[2]}"), int.parse(dayDetails[0]), int.parse(dayDetails[1]));
    scheduleDays.add(ScheduleDay(letterDay: letterDay, day: day, blocks: blocks));
  });

  return scheduleDays;
}

Future<Map<String, ScheduleDay>> getLetterDaySchedule() async{
  List<ScheduleDay> scheduleDays = await getScheduleDays();
  Map<String, ScheduleDay> finalSchedule = {};
  for(var letterDay in LetterDay.values) {
    var tempList = scheduleDays.where((element) => element.letterDay == letterDay).toList();
    ScheduleDay? regularDay;
    for (var value in tempList) {
      if(regularDay == null || value.blocks.length > regularDay.blocks.length) regularDay = value;
    }
    finalSchedule.addAll({regularDay!.letterDay.toShortString(): regularDay});
  }
  return finalSchedule;
}

Future<Map<String, ScheduleDay?>> getWeeklySchedule() async {
  final days = <String>["M", "T", "W", "TH", "F"];
  List<ScheduleDay> scheduleDays = await getScheduleDays();
  Map<String, ScheduleDay?> finalDays = {};
  DateTime startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  startOfWeek = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  if(DateTime.now().weekday > 5) startOfWeek = startOfWeek.add(const Duration(days: 7));
  for(int i = 0; i <= 4; i++) {
    ScheduleDay? day;
    try{
      day = scheduleDays.firstWhere((element) => element.day.compareTo(startOfWeek.add(Duration(days: i))) == 0);
    } catch(e) {
      day = null;
    }
    finalDays.addAll({days[i] : day});
  }
  return finalDays;
}