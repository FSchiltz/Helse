import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import '../../services/swagger_generated_code/swagger.swagger.dart';
import '../event.dart';
import 'metrics_logic.dart';

enum SubmissionStatus { initial, success, failure, inProgress }

class MetricBloc extends Bloc<ChangedEvent, MetricState> {
  MetricBloc({
    required MetricsLogic metricsLogic,
    required List<MetricType> types,
  })  : _metricsLogic = metricsLogic,
        _types = types,
        super(const MetricState()) {
    on<TextChangedEvent>(_onTextChanged);
    on<DateChangedEvent>(_onDateChanged);
    on<IntChangedEvent>(_onIntChanged);
    on<SubmittedEvent>(_onSubmitted);
  }

  final MetricsLogic _metricsLogic;
  final List<MetricType> _types;

  // Event constants
  static const String valueEvent = "value";
  static const String typeEvent = "type";
  static const String tagEvent = "tag";
  static const String dateEvent = "date";

  bool _hasError(String? text) {
    return text == null || text.isEmpty;
  }

  bool _validateAll(String? value, DateTime? date, int typeId) {
    // Metric with unit must be numeric
    var type = _types.firstWhereOrNull((element) => element.id == typeId);

    return !_hasError(value) && date != null && (type?.unit == null || double.tryParse(value!) != null);
  }

  void _onTextChanged(TextChangedEvent event, Emitter<MetricState> emit) {
    switch (event.field) {
      case valueEvent:
        _valueChanged(event.value, emit);
        break;
      case tagEvent:
        emit(
          state.copyWith(tag: event.value),
        );
        break;
    }
  }

  void _onDateChanged(DateChangedEvent event, Emitter<MetricState> emit) {
    var date = event.value;
    var valid = _validateAll(state.value, date, state.type);
    emit(
      state.copyWith(date: date, isValid: valid),
    );
  }

  void _onIntChanged(IntChangedEvent event, Emitter<MetricState> emit) {
    var type = event.value;
    var valid = _validateAll(state.value, state.date, type);
    emit(
      state.copyWith(type: type, isValid: valid),
    );
  }

  void _valueChanged(String value, Emitter<MetricState> emit) {
    var hasError = _hasError(value);
    var valid = _validateAll(value, state.date, state.type);
    emit(
      state.copyWith(value: value, valueError: hasError, isValid: valid),
    );
  }

  Future<void> _onSubmitted(SubmittedEvent event, Emitter<MetricState> emit) async {
    if (state.isValid) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        var metric = CreateMetric(date: state.date, type: state.type, tag: state.tag, value: state.value);
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
    this.tag = "",
    this.type = 1,
    this.isValid = false,
    this.date,
    this.valueError = false,
  });

  final SubmissionStatus status;

  final DateTime? date;
  final String value;
  final String tag;
  final int type;

  final bool isValid;
  final bool valueError;

  MetricState copyWith({
    SubmissionStatus? status,
    DateTime? date,
    String? value,
    String? tag,
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
      tag: tag ?? this.tag,
      valueError: valueError ?? this.valueError,
    );
  }
}
