import 'package:bloc/bloc.dart';
import 'package:helse/logic/event.dart';
import 'package:helse/logic/metrics/metrics_logic.dart';

import '../../services/swagger_generated_code/swagger.swagger.dart';

enum SubmissionStatus { initial, success, failure, inProgress }

class MetricBloc extends Bloc<ChangedEvent, MetricState> {
  MetricBloc({
    required MetricsLogic metricsLogic,
  })  : _metricsLogic = metricsLogic,
        super(const MetricState()) {
    on<TextChangedEvent>(_onTextChanged);
    on<DateChangedEvent>(_onDateChanged);
    on<IntChangedEvent>(_onIntChanged);
    on<SubmittedEvent>(_onSubmitted);
  }

  final MetricsLogic _metricsLogic;

  // Event constants
  static const String valueEvent = "value";
  static const String typeEvent = "type";
  static const String unitEvent = "unit";
  static const String dateEvent = "date";

  bool _hasError(String? text) {
    return text == null || text.isEmpty;
  }

  bool _validateAll(String? value, DateTime? date) {
    return !_hasError(value) && date != null;
  }

  void _onTextChanged(TextChangedEvent event, Emitter<MetricState> emit) {
    switch (event.field) {
      case valueEvent:
        _valueChanged(event.value, emit);
        break;
      case unitEvent:
        emit(
          state.copyWith(unit: event.value),
        );
        break;
    }
  }

  void _onDateChanged(DateChangedEvent event, Emitter<MetricState> emit) {
    var date = event.value;
    var valid = _validateAll(state.value, date);
    emit(
      state.copyWith(date: date, isValid: valid),
    );
  }

  void _onIntChanged(IntChangedEvent event, Emitter<MetricState> emit) {
    emit(
      state.copyWith(type: event.value),
    );
  }

  void _valueChanged(String value, Emitter<MetricState> emit) {
    var hasError = _hasError(value);
    var valid = _validateAll(value, state.date);
    emit(
      state.copyWith(value: value, valueError: hasError, isValid: valid),
    );
  }

  Future<void> _onSubmitted(SubmittedEvent event, Emitter<MetricState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        var metric = CreateMetric(date: state.date, type: state.type, unit: state.unit, value: state.value);
        await _metricsLogic.addMetric(metric);
        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}

final class MetricState {
  const MetricState({
    this.status = SubmissionStatus.initial,
    this.value = "",
    this.unit = "",
    this.type = 1,
    this.isValid = false,
    this.date = null,
    this.valueError = false,
  });

  final SubmissionStatus status;

  final DateTime? date;
  final String value;
  final String unit;
  final int type;

  final bool isValid;
  final bool valueError;

  MetricState copyWith({
    SubmissionStatus? status,
    DateTime? date,
    String? value,
    String? unit,
    int? type,
    bool? isValid,
    bool? valueError,
  }) {
    return MetricState(
      status: status ?? this.status,
      date: date ?? this.date,
      value: value ?? this.value,
      isValid: isValid ?? this.isValid,
      type: type ?? this.type,
      unit: unit ?? this.unit,
      valueError: valueError ?? this.valueError,
    );
  }
}
