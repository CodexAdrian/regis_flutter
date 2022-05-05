import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Schedule extends StatefulWidget {
  const Schedule({Key? key}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  List<String> letterDays = ["A", "B", "C", "D", "E", "F", "G", "H"];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Today is H day",
              style: theme.textTheme.headline2,
              textAlign: TextAlign.left,
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
                        onPressed: () {},
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
        ],
      ),
    );
  }
}
