import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts; // Add this import
import 'package:theme_provider/theme_provider.dart';
import 'grade.dart';

class GradeChartPage extends StatelessWidget {
  final List<Grade> grades;

  GradeChartPage({required this.grades});

  @override
  Widget build(BuildContext context) {
    List<charts.Series<Grade, String>> series = [
      charts.Series(
        id: 'Grades',
        data: grades, // Provide the correct data here
        domainFn: (Grade grade, _) => grade.grade!,
        measureFn: (Grade grade, _) => grades
            .where((g) => g.grade == grade.grade)
            .toList()
            .length
            .toDouble(),
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (Grade grade, _) =>
            '${grade.grade}: ${grades.where((g) => g.grade == grade.grade).toList().length}',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Grade Data Chart'),
        actions: <Widget>[
          // Dark mode toggle button
          IconButton(
            icon: Icon(Icons.sunny_snowing),
            onPressed: () {
              ThemeProvider.controllerOf(context).nextTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: charts.BarChart(
              series,
              animate: true,
              barGroupingType: charts.BarGroupingType.grouped,
              barRendererDecorator: charts.BarLabelDecorator<String>(),
              domainAxis: charts.OrdinalAxisSpec(),
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(),
              ),
              behaviors: [
                charts.SeriesLegend(
                  position: charts.BehaviorPosition.end,
                  horizontalFirst: false,
                  cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                  showMeasures: true,
                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                ),
              ],
              defaultRenderer: charts.BarRendererConfig(
                maxBarWidthPx: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
