import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailFigure extends StatelessWidget {
  final String title;
  final Map<String, dynamic> data;
  final Color color;

  DetailFigure({required this.title, required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: color, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 16.0),
          AspectRatio(
            aspectRatio: 1.5,
            child: PieChart(
              PieChartData(
                sections: data.entries.map((entry) {
                  return PieChartSectionData(
                    color: color,
                    value: entry.value.toDouble(),
                    title: '${entry.key}: ${entry.value}',
                    titleStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
