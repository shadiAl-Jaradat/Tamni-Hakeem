import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedBarChart extends StatefulWidget {
  final ValueChanged<int?> onBarTouched;
  const RoundedBarChart({required this.onBarTouched});
  @override
  State<RoundedBarChart> createState() => _RoundedBarChartState();
}

class _RoundedBarChartState extends State<RoundedBarChart> {
  int touchedIndex = 7;
  List<String> years = [
    "٢٠١٦",
    "٢٠١٧",
    "٢٠١٨",
    "٢٠١٩",
    "٢٠٢٠",
    "٢٠٢١",
    "٢٠٢٢",
    "٢٠٢٣"];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),

          alignment: BarChartAlignment.center,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.transparent,

            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions && barTouchResponse != null) {
                  if(barTouchResponse.spot != null) {
                    touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
                    widget.onBarTouched(touchedIndex);
                  }
                }
                // Notify the callback about the touch
              });
            },
            handleBuiltInTouches: true,
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (double value, TitleMeta) {
                    int index = value.toInt();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        years[index],
                        style:  GoogleFonts.tajawal(
                          color: Color(0xff0B3C42),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    );
                  },
                )
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: _buildBarGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final List<double> values = [
      769,
      200,
      600,
      1200,
      550,
      400,
      700,
      800];
    return List.generate(values.length, (index) {
      return _buildBar(
        x: index,
        y: values[index],
        isTouched: index == touchedIndex,
      );
    });
  }

  BarChartGroupData _buildBar({
    bool isTouched = false,
    required int x,
    required double y
  }){
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          color: isTouched ? const Color(0xff752C20) : Colors.grey.shade300.withOpacity(0.9),
          width: 40,
          toY:   y,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.zero,
            bottomRight: Radius.zero,
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      ],
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }
}