import 'package:bio_watch/components/BarGraph.dart';
import 'package:bio_watch/components/PieGraph.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/Participant.dart';
import 'package:bio_watch/shared/decorations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statistics extends StatelessWidget {
  final DateTime createdAt;
  final DateTime conductedAt;

  Statistics({this.createdAt, this.conductedAt});

  @override
  Widget build(BuildContext context) {
    final interested = Provider.of<List<Interested>>(context);
    final participants = Provider.of<List<Participant>>(context);
    final theme = Theme.of(context);

    List<List> getBarChartData() {
      int count = 0;
      int index = 0;
      List<DateTime> dates = interested.map((date) => DateTime.parse(date.datetime)).toList();
      List<List> chartData = [];
      for(int day = createdAt.day; day <= conductedAt.day; day++) {
        count += dates.where((date) => date.day == day).length;
        chartData.add([dateFormatter2.format(createdAt.add(Duration(days: index))), count]);
        index++;
      }
      return chartData;
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(Icons.bookmark_rounded, size: 30, color: Colors.grey[700]),
                              Text('${interested.length}', style: theme.textTheme.headline4.copyWith(fontSize: 29)),
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Icon(Icons.directions_walk_rounded, size: 30, color: Colors.grey[700]),
                              Text('${participants.length}', style: theme.textTheme.headline4.copyWith(fontSize: 29)),
                            ],
                          ),
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 9, child: Card(child: PieGraph(attendees: participants.length, absentees: interested.length - participants.length))),
            Expanded(flex: 12, child: Card(child: BarGraph(interested: getBarChartData())))
          ],
        ),
      ),
    );
  }
}
