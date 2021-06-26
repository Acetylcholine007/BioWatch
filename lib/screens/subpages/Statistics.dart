import 'package:bio_watch/components/BarGraph.dart';
import 'package:bio_watch/components/PieGraph.dart';
import 'package:bio_watch/models/Interested.dart';
import 'package:bio_watch/models/Participant.dart';
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
      List<DateTime> dates = interested.map((date) => DateTime.parse(date.datetime)).toList();
      List<List> chartData = [];
      for(int day = createdAt.day; day <= conductedAt.day; day++) {
        count += dates.where((date) => date.day == day).length;
        chartData.add([day.toString(), count]);
      }
      return chartData;
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Interested', style: theme.textTheme.headline4),
                    Text('${interested.length}', style: theme.textTheme.headline5)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Participants', style: theme.textTheme.headline4),
                    Text('${participants.length}', style: theme.textTheme.headline5)
                  ],
                )
              ],
            ),
          ),
          Divider(height: 20),
          Expanded(flex: 1, child: Text('Attendance summary', style: theme.textTheme.headline5)),
          Expanded(flex: 4, child: PieGraph(attendees: participants.length, absentees: interested.length - participants.length)),
          Expanded(flex: 1, child: Text('Popularity Chart', style: theme.textTheme.headline5)),
          Expanded(flex: 5, child: BarGraph(interested: getBarChartData()))
        ],
      ),
    );
  }
}
