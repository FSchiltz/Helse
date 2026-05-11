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
  Map<String, int> _eventTypeCounts = {};
  List<EventDateSummary> _eventSummaries = [];
  List<Person> _recentUsers = [];
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

    // Load users created in the last 7 days
    final allPersons = await DI.user.persons() ?? [];
    _recentUsers = allPersons
        .where(
          (p) =>
              p.birth != null &&
              p.birth!.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              ),
        )
        .toList();

    // Load event type counts for the last 7 days
    final recentEvents =
        await DI.event.events(
          null,
          DateTime.now().subtract(const Duration(days: 7)),
          end,
        ) ??
        [];
    final allEventTypes = await DI.event.eventsType(false) ?? [];
    final typeNameById = {for (var type in allEventTypes) type.id: type.name};
    _eventTypeCounts = {};
    for (final event in recentEvents) {
      final typeName = typeNameById[event.type] ?? 'Unknown';
      _eventTypeCounts[typeName] = (_eventTypeCounts[typeName] ?? 0) + 1;
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
          const Text(
            'User Statistics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Quick Counts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildUserStats(),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Users',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRecentUsers(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Events Over Time',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [              
              SizedBox(
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Daily Volume',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEventsBarChart(),
                    ],
                  ),
                ),
              ),SizedBox(
                width: 420,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Events by Type (last 7 days)',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildEventTypeCounts(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentUsers() {
    if (_recentUsers.isEmpty) {
      return const Text('No users created in the last 7 days');
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: _recentUsers.length,
        itemBuilder: (context, index) {
          final user = _recentUsers[index];
          final fullName = '${user.name ?? ''} ${user.surname ?? ''}'.trim();
          return ListTile(
            title: Text(fullName.isEmpty ? 'Unknown' : fullName),
            subtitle: Text(
              'Born: ${user.birth?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventTypeCounts() {
    if (_eventTypeCounts.isEmpty) {
      return const Text('No events created in the last 7 days');
    }

    final sortedTypes = _eventTypeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: sortedTypes.length,
        itemBuilder: (context, index) {
          final entry = sortedTypes[index];
          return ListTile(
            title: Text(entry.key),
            trailing: Text(
              entry.value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: _userCounts.entries.map((entry) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.value.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(entry.key, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEventsBarChart() {
    if (_eventSummaries.isEmpty) {
      return const Text('No event data available');
    }

    final barGroups = _eventSummaries.asMap().entries.map((entry) {
      final index = entry.key;
      final summary = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: summary.count.toDouble(),
            color: Colors.teal,
            width: 18,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    String _labelForIndex(double value) {
      final index = value.toInt();
      if (index < 0 || index >= _eventSummaries.length) {
        return '';
      }
      final date = _eventSummaries[index].date;
      return '${date.month}/${date.day}';
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: barGroups,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _labelForIndex(value),
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }
}
