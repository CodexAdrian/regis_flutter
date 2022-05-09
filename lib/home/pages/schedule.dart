import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

  }

  loadSchedule() async {
    days = await getWeeklySchedule();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: text(
              "Today is H day",
              theme.textTheme.headline2!,
            ),
          ),
          SizedBox(
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: letterDays
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: theme.cardColor,
                        ),
                        onPressed: () {

                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Center(
                            child: Text(
                              e,
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
                  FutureBuilder<Map<String, ScheduleDay?>>(
                    future: getWeeklySchedule(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Text("Error");
                      } else if (snapshot.hasData) {
                        var element = snapshot.data!.entries.first;
                        return Column(children: [
                          if (element.value != null)
                            ScheduleCard(scheduleDay: element.value!)
                          else
                            const Card(
                              child: Text("Non-Instructional School Day"),
                            )
                        ]);
                      } else {
                        return LoadingScreen();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
