import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:helse/helpers/date.dart';
import 'package:helse/di/dependencies.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';
import 'package:helse/ui/common/layout/common_card.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  List<CountRecord> _userCounts = [];
  List<CountRecord> _eventTypeCounts = [];
  List<CountByDate> _eventSummaries = [];

  List<CountRecord> _metricTypeCounts = [];
  List<CountByDate> _metricSummaries = [];
  bool _loading = true;

  List<JobResultInfo> _jobs = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    // Load user stats from admin endpoint
    final userStats = await Dependencies.services.admin.getUserStats();
    if (userStats != null) {
      _userCounts = userStats.userCount;
    }

    // Load event summaries for the last 30 days
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 30));
    var events = await Dependencies.services.admin.getEventStats(start, end);
    if (events != null) {
      _eventSummaries = events.events;
      _eventTypeCounts = events.eventCounts;
    }

    var metrics = await Dependencies.services.admin.getmetricStats(start, end);
    if (metrics != null) {
      _metricSummaries = metrics.events;
      _metricTypeCounts = metrics.eventCounts;
    }

    _jobs = await Dependencies.services.admin.getJobs();

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
                  child: _buildUserStats(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Metrics',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              countGraph(_metricSummaries),
              countTypeGraph(_metricTypeCounts),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Events',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              countGraph(_eventSummaries),
              countTypeGraph(_eventTypeCounts),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'Jobs',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            itemCount: _jobs.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              var job = _jobs[index];
              var task = job.result;
              var theme = Theme.of(context).textTheme;
              return CommonCard(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${task.description} at ${DateHelper.format(task.start, context: context)}',
                        style: theme.bodyLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        task.status?.name.toString() ?? '',
                        style: theme.bodyLarge,
                      ),
                    ),
                
                    if (task.progress != null &&
                        (task.progress ?? 0) < 100) ...[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${task.progress?.toStringAsFixed(2)}%',
                          style: theme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          height: 12,
                          child: LinearProgressIndicator(
                            value: (task.progress ?? 0) / 100,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  SizedBox countTypeGraph(List<CountRecord> counts) {
    final sortedTypes = counts.toList()
      ..sort((a, b) => b.count.compareTo(a.count));

    return SizedBox(
      width: 420,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Count by Type (last 7 days)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: sortedTypes.length,
                itemBuilder: (context, index) {
                  final entry = sortedTypes[index];
                  return ListTile(
                    title: Text(entry.id),
                    trailing: Text(
                      entry.count.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String labelForIndex(double value, List<CountByDate> counts) {
    final index = value.toInt();
    if (index < 0 || index >= counts.length) {
      return '';
    }
    final date = counts[index].date;
    return '${date.month}/${date.day}';
  }

  SizedBox countGraph(List<CountByDate> counts) {
    final barGroups = counts.asMap().entries.map((entry) {
      final index = entry.key;
      final summary = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: summary.count.toDouble(),
            color: Colors.teal,
            width: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return SizedBox(
      width: 420,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record added',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                labelForIndex(value, counts),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 3,
      physics: const NeverScrollableScrollPhysics(),
      children: _userCounts.map((entry) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.count.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(entry.id, style: const TextStyle(fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }
}
