import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PieChartWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State {
  List<PieChartSectionData> _pieChartData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData(); // This will now fetch dummy data
  }

  Future<void> _fetchData() async {
     await Future.delayed(const Duration(seconds: 1));

    // Dummy data structure
    final List<Map<String, dynamic>> dummyRawData = [
      {'name': 'Milestone 1', 'value': 90},
      {'name': 'Milestone 2', 'value': 65},
      {'name': 'Milestone 3', 'value': 15},
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
          title: '${percentage.toStringAsFixed(0)}%',
          radius: 50, // Keep this relatively small for responsive circles
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
    // You can extend this with more colors if you have more categories
    switch (category) {
      case 'Milestone 1':
        return Colors.red.shade400;
      case 'Milestone 2':
        return Colors.blue.shade600;
      case 'Milestone 3':
        return Colors.purple.shade400;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : AspectRatio(
      aspectRatio: 1,
      child: PieChart(
        PieChartData(
          sections: _pieChartData,
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 40, // Adjust this for the center hole size
          sectionsSpace: 2, // Space between slices
         ),
      ),
    );
  }
}