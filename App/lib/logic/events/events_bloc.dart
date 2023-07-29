import 'package:bloc/bloc.dart';

import '../../main.dart';
import '../../services/swagger/generated_code/swagger.swagger.dart';
import '../event.dart';

class EventBloc extends Bloc<ChangedEvent, EventState> {
  EventBloc() : super(const EventState()) {
    on<TextChangedEvent>(_onTextChanged);
    on<DateChangedEvent>(_onDateChanged);
    on<IntChangedEvent>(_onIntChanged);
    on<SubmittedEvent>(_onSubmitted);
  }

  // Event constants
  static const String descriptionEvent = "description";
  static const String typeEvent = "type";
  static const String dateEndEvent = "end";
  static const String dateStartEvent = "start";

  bool _hasError(String? text) {
    return text == null || text.isEmpty;
  }

  bool _validateAll(String? value, DateTime? start, DateTime? end) {
    return !_hasError(value) && start != null && end != null;
  }

  void _onTextChanged(TextChangedEvent event, Emitter<EventState> emit) {
    switch (event.field) {
      case descriptionEvent:
        _valueChanged(event.value, emit);
        break;
    }
  }

  void _onDateChanged(DateChangedEvent event, Emitter<EventState> emit) {
    switch (event.field) {
      case dateEndEvent:
        var date = event.value;
        var valid = _validateAll(state.description, state.start, date);
        emit(
          state.copyWith(stop: date, isValid: valid),
        );
        break;
      case dateStartEvent:
        var date = event.value;
        var valid = _validateAll(state.description, date, state.stop);
        emit(
          state.copyWith(start: date, isValid: valid),
        );
        break;
    }
  }

  void _onIntChanged(IntChangedEvent event, Emitter<EventState> emit) {
    var type = event.value;
    emit(
      state.copyWith(type: type),
    );
  }

  void _valueChanged(String value, Emitter<EventState> emit) {
    var hasError = _hasError(value);
    var valid = _validateAll(value, state.start, state.stop);
    emit(
      state.copyWith(description: value, descriptionError: hasError, isValid: valid),
    );
  }

  Future<void> _onSubmitted(SubmittedEvent event, Emitter<EventState> emit) async {
    if (state.isValid && AppState.metricsLogic != null) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        var metric = CreateEvent(start: state.start, stop: state.stop, type: state.type, description: state.description);
        await AppState.eventLogic?.addEvent(metric);

        event.callback?.call();

        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}

final class EventState {
  const EventState({
    this.status = SubmissionStatus.initial,
    this.description = "",
    this.type = 1,
    this.isValid = false,
    this.start,
    this.stop,
    this.descriptionError = false,
  });

  final SubmissionStatus status;

  final DateTime? start;
  final DateTime? stop;
  final String description;
  final int type;

  final bool isValid;
  final bool descriptionError;

  EventState copyWith({
    SubmissionStatus? status,
    DateTime? start,
    DateTime? stop,
    String? description,
    int? type,
    bool? isValid,
    bool? descriptionError,
  }) {
    return EventState(
      status: status ?? this.status,
      start: start ?? this.start,
      stop: stop ?? this.stop,
      description: description ?? this.description,
      isValid: isValid ?? this.isValid,
      type: type ?? this.type,
      descriptionError: descriptionError ?? this.descriptionError,
    );
  }
}
