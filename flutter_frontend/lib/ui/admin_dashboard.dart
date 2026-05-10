import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  Map<String, int> _userCounts = {};
  List<EventDateSummary> _eventSummaries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // Load user stats from admin endpoint
    final userStats = await DI.admin.getUserStats();
    if (userStats != null) {
      _userCounts = {
        'Total Users': userStats.totalUsers,
        'Patients': userStats.patients,
        'Caregivers': userStats.caregivers,
        'Admins': userStats.admins,
      };
    }

    // Load event summaries for the last 30 days
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 30));
    _eventSummaries = await DI.admin.getEventStats(start, end) ?? [];

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildUserStats(),
          const SizedBox(height: 32),
          const Text(
            'Events Over Time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildEventsChart(),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return GridView.count(
      crossAxisCount: 6,
      shrinkWrap: true,
      children: _userCounts.entries.map((entry) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              entry.value.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(entry.key, style: const TextStyle(fontSize: 16)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEventsChart() {
    if (_eventSummaries.isEmpty) {
      return const Text('No event data available');
    }

    // The event summaries are already grouped by date
    final spots = _eventSummaries.asMap().entries.map((entry) {
      final summary = _eventSummaries[entry.key];
      return FlSpot(entry.key.toDouble(), summary.count.toDouble());
    }).toList();

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  } 
}
