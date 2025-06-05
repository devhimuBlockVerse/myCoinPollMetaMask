import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State {
  List<PieChartSectionData> _pieChartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  /// Dummy data for pie chart
  Future<void> _fetchData() async {
     await Future.delayed(const Duration(seconds: 1));

    // Dummy data structure
    final List<Map<String, dynamic>> dummyRawData = [
      {'name': 'Achieved', 'value': 90},
      {'name': 'Completed', 'value': 65},
      {'name': 'Couldn’t Achieved', 'value': 15},
     ];

    try {
      _pieChartData = _processData(dummyRawData);
    } catch (error) {
      print('Error processing dummy data: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<PieChartSectionData> _processData(List<dynamic> rawData) {
    List<PieChartSectionData> processedData = [];
    double totalValue = rawData.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());

    for (var item in rawData) {
      final String name = item['name'];
      final double value = (item['value'] as num).toDouble();
      final Color color = _getColor(name);

      double percentage = (totalValue > 0) ? (value / totalValue) * 100 : 0.0;

      processedData.add(
        PieChartSectionData(
          color: color,
          value: percentage,
          title: value.toStringAsFixed(0),
          // radius: 30,
          radius: 50,
          borderSide: const BorderSide(
            color: Colors.white,
            width: 1,
          ),
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    return processedData;
  }

  Color _getColor(String category) {
     switch (category) {
      case 'Achieved':
        return const Color(0xff980C41);
      case 'Completed':
        return const Color(0xff2563EB);
      case 'Couldn’t Achieved':
        return const Color(0xff4F378A);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : AspectRatio(
      aspectRatio: 1,
      child: PieChart(

        PieChartData(
           sections: _pieChartData,
          borderData: FlBorderData(show: false),
          // centerSpaceRadius: 42,
          centerSpaceRadius: 30,
            sectionsSpace: 0,
          ),

      ),
    );
  }
}