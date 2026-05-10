import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/logic/d_i.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class AdminStats extends StatefulWidget {
  const AdminStats({super.key});

  @override
  State<AdminStats> createState() => _AdminStatsState();
}

class _AdminStatsState extends State<AdminStats> {
  Map<String, int> _userCounts = {};
  List<EventDateSummary> _eventSummaries = [];
  List<MetricType> _metricTypes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
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

      // Load metric types
      _metricTypes = await DI.metric.metricsType(true) ?? [];
    } catch (e) {
      // Handle error
    }

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
          const Text('User Statistics', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildUserStats(),
          const SizedBox(height: 32),
          const Text('Events Over Time', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildEventsChart(),
          const SizedBox(height: 32),
          const Text('Metric Types', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildMetricTypesList(),
        ],
      ),
    );
  }

  Widget _buildUserStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _userCounts.entries.map((entry) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(entry.value.toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                Text(entry.key, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
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

  Widget _buildMetricTypesList() {
    if (_metricTypes.isEmpty) {
      return const Text('No metric types available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _metricTypes.length,
      itemBuilder: (context, index) {
        final type = _metricTypes[index];
        return ListTile(
          title: Text(type.name),
          subtitle: Text(type.unit ?? ''),
        );
      },
    );
  }
}