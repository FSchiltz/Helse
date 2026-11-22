import 'package:flutter_test/flutter_test.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/task_bloc.dart';

void main() {
  test('reports external task progress and completion', () async {
    var actionCalled = false;
    final bloc = TaskBloc(
      () async {
        actionCalled = true;
        return Execution.empty();
      },
      const Duration(seconds: 1),
      () => true,
    );
    addTearDown(bloc.close);

    bloc.startReport(title: 'Offline sync', status: 'Preparing');
    bloc.updateReport(status: 'Syncing metrics', progress: 50);
    await bloc.execute();

    expect(actionCalled, isFalse);
    expect(bloc.state.state, SubmissionStatus.inProgress);
    expect(bloc.state.title, 'Offline sync');
    expect(bloc.state.status, 'Syncing metrics');
    expect(bloc.state.progress, 50);

    bloc.finishReport(success: true, status: 'Complete');

    expect(bloc.state.state, SubmissionStatus.success);
    expect(bloc.state.progress, 100);
    expect(bloc.reportedExecutions, hasLength(1));
    expect(bloc.reportedExecutions.single.status, 'Complete');
  });
}
