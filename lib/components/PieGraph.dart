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
    return PieChart(
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
    );
  }
}