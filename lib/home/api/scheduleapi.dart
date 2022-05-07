
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

class ScheduleDay {
  final LetterDay letterDay;
  final DateTime day;
  final List<ScheduleBlock> blocks;

  ScheduleDay({required this.letterDay, required this.day, required this.blocks});
}

class ScheduleBlock {
  final String location;
  final String zoomLink;
  final String name;
  final TimeOfDay timeStart;
  final TimeOfDay timeEnd;

  ScheduleBlock({required this.location, required this.zoomLink, required this.name, required this.timeStart, required this.timeEnd});
}

enum LetterDay {
  A, B, C, D, E, F, G, H
}

getScheduleDay() async {
  final input = File('assets/schedule.csv').readAsStringSync();
  final fields = CsvToListConverter().convert(input);
  print(fields);
}