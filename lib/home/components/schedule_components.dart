import 'package:flutter/material.dart';
import 'package:regis_flutter/home/api/scheduleapi.dart';

class ScheduleDisplay extends StatefulWidget {
  final List<ScheduleDay> scheduleDays;

  const ScheduleDisplay({Key? key, required this.scheduleDays}) : super(key: key);

  @override
  State<ScheduleDisplay> createState() => _ScheduleDisplayState();
}

class _ScheduleDisplayState extends State<ScheduleDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ScheduleCard extends StatelessWidget {
  final ScheduleDay scheduleDay;

  const ScheduleCard({Key? key, required this.scheduleDay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    int occupiedSlots = 0;
    int filledSlots = 0;
    for (var element in scheduleDay.blocks) {
      occupiedSlots += element.getModLength();
    }
    List<ScheduleBlock?> slots = List.filled(21 - occupiedSlots + scheduleDay.blocks.length, null, growable: true);
    for (var element in scheduleDay.blocks) {
      slots.insert(element.getModStart() - filledSlots, element);
      filledSlots += element.getModLength() - 1;
    }
    int boxSize = 55;
    return Column(
      children: slots.map(
        (e) {
          if (e == null) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: Colors.white10),
              ),
              child: SizedBox(
                height: boxSize.toDouble(),
                child: const FractionallySizedBox(widthFactor: 1),
              ),
            );
          } else {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: Colors.white10),
              ),
              child: SizedBox(
                height: (boxSize * e.getModLength()).toDouble(),
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.name,
                          style: theme.textTheme.headline3,
                        ),
                        Text(
                          e.location.isNotEmpty ?
                          "${e.location} (${formatTime(e.timeStart!)} - ${formatTime(e.timeEnd!)})" : "${formatTime(e.timeStart!)} - ${formatTime(e.timeEnd!)}",
                          style: theme.textTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ).toList(),
    );
  }

  String formatTime(TimeOfDay timeOfDay) {
    int hours = (timeOfDay.hour - 1) % 12 + 1;
    String meridian = timeOfDay.hour >= 12 ? "PM" : "AM";
    String minutes = timeOfDay.minute.bitLength < 2 ? "0${timeOfDay.minute}" : timeOfDay.minute.toString();
    return "$hours:$minutes $meridian";
  }
}
