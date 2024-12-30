import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final int malePopulation;
  final int femalePopulation;
  final int maleEmployed;
  final int femaleEmployed;
  final Map<String, dynamic> educationSummary;

  DetailCard({
    required this.malePopulation,
    required this.femalePopulation,
    required this.maleEmployed,
    required this.femaleEmployed,
    required this.educationSummary,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          Text(
            'Population Summary',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 16),
          // Population Pie Chart
          Center(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: malePopulation.toDouble(),
                          title: 'Male: $malePopulation',
                          color: Colors.blue,
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: femalePopulation.toDouble(),
                          title: 'Female: $femalePopulation',
                          color: Colors.pink,
                          radius: 50,
                        ),
                      ],
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Population: ${malePopulation + femalePopulation}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 80),
          Text(
            'Education Summary',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 16),
          // Education Bar Chart
          Container(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: educationSummary.entries.map((entry) {
                  final value = entry.value is int
                      ? entry.value as int
                      : int.tryParse(entry.value.toString()) ?? 0; // Safely cast
                  return BarChartGroupData(
                    x: educationSummary.keys.toList().indexOf(entry.key),
                    barRods: [
                      BarChartRodData(
                        toY: value.toDouble(),
                        color: Colors.orange,
                        width: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value >= 1000) {
                          return Text(
                            '${(value / 1000).round()}K',
                            style: TextStyle(fontSize: 10),
                          );
                        }
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < educationSummary.keys.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              educationSummary.keys.elementAt(value.toInt()),
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                alignment: BarChartAlignment.spaceEvenly,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final educationLevel =
                          educationSummary.keys.elementAt(group.x);
                      final value = rod.toY.toInt();
                      return BarTooltipItem(
                        '$educationLevel\n$value',
                        TextStyle(color: Colors.white),
                      );
                    },
                  ),
                  handleBuiltInTouches: true,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    left: BorderSide(color: Colors.grey),
                    bottom: BorderSide(color: Colors.grey),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 10000,
                  drawVerticalLine: false,
                ),
                maxY: educationSummary.values
                    .map((v) => v is int ? v : int.tryParse(v.toString()) ?? 0)
                    .reduce((a, b) => a > b ? a : b)
                    .toDouble(),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Employment Summary',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: 16),
          // Employment Pie Chart
          Center(
            child: Column(
              children: [
                Container(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: maleEmployed.toDouble(),
                          title: 'Male: $maleEmployed',
                          color: Colors.blue,
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: femaleEmployed.toDouble(),
                          title: 'Female: $femaleEmployed',
                          color: Colors.pink,
                          radius: 50,
                        ),
                      ],
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Total Employed: ${maleEmployed + femaleEmployed}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
