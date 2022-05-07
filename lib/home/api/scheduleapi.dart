
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
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
  final String timeStart;
  final String timeEnd;
  final String? letterDay;

  ScheduleBlock({required this.location, required this.name, required this.timeStart, required this.timeEnd, this.letterDay});
}

enum LetterDay {
  A, B, C, D, E, F, G, H
}

getScheduleDays() async {
  final data = await rootBundle.loadString('assets/schedule.csv');
  final stuff = const CsvToListConverter(fieldDelimiter: ",", eol: "\\n").convert(data).toList();
  stuff.remove(stuff[0]);
  print(stuff[0]);
  final classDays = ListMultimap<String, ScheduleBlock>();
  for (List<dynamic> e in stuff) {
    print("stuff added");
    print("VALUE: ${e[0]}");
    classDays.add(e[0], ScheduleBlock(location: e[5], name: e[4], timeStart: e[1], timeEnd: e[2], letterDay: e[7]==1 ? e[4] : null));
  }
  List<ScheduleDay> scheduleDays = List.empty(growable: true);
  classDays.asMap().forEach((dayString, blocks) {
    final letterDayBlock = blocks.firstWhere((element) => element.letterDay!= null);
    String letterDayString = letterDayBlock.letterDay![0];
    blocks.remove(letterDayBlock);
    LetterDay letterDay = LetterDay.values.firstWhere((element) => element.toString() == letterDayString);
    print(dayString);
    final day = DateTime.parse(dayString.replaceAll("/", "-"));
    scheduleDays.add(ScheduleDay(letterDay: letterDay, day: day, blocks: blocks));
  });
  print(scheduleDays);
}