import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ResultsPage extends StatelessWidget {
  final int assessment1Results;
  final int assessment2Results;
  final int assessment3Results;

  ResultsPage({
    required this.assessment1Results,
    required this.assessment2Results,
    required this.assessment3Results,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total score for pie chart
    final totalScore = assessment1Results + assessment2Results + assessment3Results;

    return Scaffold(
      appBar: AppBar(
        title: Text('Test Results'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Total Score
            Text(
              'Your Total Score: $totalScore',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            
            // Pie Chart for Assessment Results
            Text(
              'Score Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,  // Adjust container size for pie chart
              child: buildPieChart(totalScore),
            ),
            
            SizedBox(height: 20),
            
            // Bar Chart for individual assessment results
            Text(
              'Score Breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,  // Adjust container size for bar chart
              child: buildBarChart(assessment1Results, assessment2Results, assessment3Results),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build Pie Chart
  Widget buildPieChart(int totalScore) {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(
            value: assessment1Results.toDouble(),
            color: Colors.blue,
            title: 'Test 1: $assessment1Results',
            radius: 80,
            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: assessment2Results.toDouble(),
            color: Colors.green,
            title: 'Test 2: $assessment2Results',
            radius: 80,
            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            value: assessment3Results.toDouble(),
            color: Colors.orange,
            title: 'Test 3: $assessment3Results',
            radius: 80,
            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
        sectionsSpace: 2,
        centerSpaceRadius: 50,
      ),
    );
  }

  // Method to build Bar Chart
  Widget buildBarChart(int score1, int score2, int score3) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceEvenly,
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [BarChartRodData(toY: score1.toDouble(), color: Colors.blue, width: 15)],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [BarChartRodData(toY: score2.toDouble(), color: Colors.green, width: 15)],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [BarChartRodData(toY: score3.toDouble(), color: Colors.orange, width: 15)],
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return Text('Test 1');
                  case 1:
                    return Text('Test 2');
                  case 2:
                    return Text('Test 3');
                }
                return Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
