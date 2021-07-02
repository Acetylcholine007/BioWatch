import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart';

class BarGraph extends StatefulWidget {
  final List<List> interested;

  BarGraph({this.interested});

  @override
  _BarGraphState createState() => _BarGraphState(interested.length);
}

class _BarGraphState extends State<BarGraph> {
  _BarGraphState(this.dataLength);

  int dataLength;
  int sectionLength = 7;
  int offset = 0;
  int step = 2;

  List<Series<dynamic, String>> generateSeries() {
    return [
      Series(
        id: 'Interested',
        domainFn: (point, _) => point[0],
        measureFn: (point, _) => point[1],
        data: widget.interested.length >= sectionLength ?
        widget.interested.sublist(offset, offset + sectionLength) : widget.interested.sublist(0, widget.interested.length),
        labelAccessorFn: (point, _) => '${point[1]}'
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(flex: 1, child: Center(child: Text('Attendance summary', style: theme.textTheme.headline4.copyWith(fontSize: 30)))),
        Expanded(
          flex: 4,
          child: BarChart(
            generateSeries(),
            animate: true,
            barRendererDecorator: BarLabelDecorator<String>(),
            domainAxis: OrdinalAxisSpec(
              renderSpec: SmallTickRendererSpec(labelRotation: 60),
            ),
          ),
        ),
        Expanded(flex: 1, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => offset = offset - step >= 0 ? offset - step : 0),
              onLongPress: () => setState(() => offset = 0),
              child: Text('< BACK')),
            ElevatedButton(
              onPressed: () => setState(() => offset = offset + step < dataLength - sectionLength ? offset + step : dataLength - sectionLength),
              onLongPress: () => setState(() => offset = dataLength - sectionLength),
              child: Text('NEXT >'))
          ],
        ))
      ],
    );
  }
}