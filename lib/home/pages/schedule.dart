import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../api/scheduleapi.dart';
import '../components/base_components.dart';
import '../components/schedule_components.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> letterDays = ["A", "B", "C", "D", "E", "F", "G", "H"];
  late Map<String, ScheduleDay?> days;
  int index = 0;
  bool _isLoading = true;
  bool weeklyShown = true;

  @override
  void initState() {
    super.initState();
    loadWeeklySchedule();
  }

  loadWeeklySchedule() async {
    days = await getWeeklySchedule();
    setState(() => _isLoading = false);
  }

  loadLetterDaySchedule() async {
    days = await getLetterDaySchedule();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return _isLoading
        ? const LoadingScreen()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Scaffold(
              body: Column(
                children: [
                  if (weeklyShown)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: text(
                        days.entries.elementAt(index).value != null ? "Today is ${days.entries.elementAt(index).value!.letterDay.toShortString()} day" : "Non-Instructional Day",
                        theme.textTheme.headline2!,
                      ),
                    ),
                  SizedBox(
                    height: 70,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: days.entries
                          .toList()
                          .asMap()
                          .entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: e.key == index ? theme.primaryColor : theme.cardColor,
                                ),
                                onPressed: () {
                                  setState(() => index = e.key);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Center(
                                    child: Text(
                                      e.value.key,
                                      style: theme.textTheme.headline2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          if (days.entries.elementAt(index).value != null)
                            ScheduleCard(scheduleDay: days.entries.elementAt(index).value!)
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 325,
                                  child: SvgPicture.asset("assets/icons/meditation.svg"),
                                ),
                                Text(
                                  "Non-Instructional Day",
                                  style: theme.textTheme.headline2,
                                ),
                                Text(
                                  "Enjoy your day off!",
                                  style: theme.textTheme.subtitle1,
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.settings, color: Colors.white, size: 32),
                onPressed: () {
                  setState(() {
                    if (weeklyShown) {
                      weeklyShown = !weeklyShown;
                      loadLetterDaySchedule();
                      index = 0;
                      return;
                    } else {
                      weeklyShown = !weeklyShown;
                      loadWeeklySchedule();
                      index = 0;
                      return;
                    }
                  });
                },
              ),
            ),
          );
  }
}
