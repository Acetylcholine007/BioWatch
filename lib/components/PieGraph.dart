import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class PieGraph extends StatelessWidget {
  final int attendees;
  final int absentees;

  PieGraph({this.attendees, this.absentees});

  List<Series> generateSeries() {
    return [
      Series(
        id: 'Attendees',
        data: [
          ['Attendees', attendees],
          ['Absentees', absentees]
        ],
        domainFn: (point, _) => point[0],
        measureFn: (point, _) => point[1],
        labelAccessorFn: (point, _) => '${point[0]}:\n${point[1]}'
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(flex: 1, child: Center(child: Text('Popularity Chart', style: theme.textTheme.headline4.copyWith(fontSize: 30)))),
        ] + (attendees == 0 && absentees == 0 ? [
          Expanded(flex: 2, child: Center(child: Icon(Icons.group_rounded, size: 100, color: theme.primaryColor))),
          Expanded(flex: 2, child: Center(child: Text('Nobody is taking up interest yet', style: theme.textTheme.headline4.copyWith(fontSize: 20)))),
      ] : [
        Expanded(
          flex: 4,
          child: PieChart(
            generateSeries(),
            animate: true,
            defaultRenderer: ArcRendererConfig(
              arcRendererDecorators: [
                ArcLabelDecorator()
              ]
            ),
            behaviors: [
              DatumLegend(
                position: BehaviorPosition.end,
                desiredMaxRows: 2,
                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0)
              )
            ],
          ),
        ),
      ]),
    );
  }
}