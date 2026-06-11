import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AttendanceChart extends StatelessWidget {
  const AttendanceChart({super.key, required int presentToday, required int totalStudents, required int absentToday});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Attendance Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 300,

              child: BarChart(
                BarChartData(
                  borderData:
                      FlBorderData(show: false),

                  titlesData: FlTitlesData(
                    leftTitles:
                        AxisTitles(
                      sideTitles:
                          SideTitles(
                        showTitles: true,
                      ),
                    ),
                  ),

                  barGroups: [
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 194,
                          width: 30,
                        ),
                      ],
                    ),

                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 54,
                          width: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}