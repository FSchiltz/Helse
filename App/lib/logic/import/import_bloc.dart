import 'package:bloc/bloc.dart';
import 'package:file_selector/file_selector.dart';

import '../../main.dart';
import '../../services/swagger_generated_code/swagger.swagger.dart';
import '../event.dart';

class ImportBloc extends Bloc<ChangedEvent, ImportState> {
  ImportBloc({
    required List<FileType> types,
  })  : _types = types,
        super(const ImportState()) {
    on<IntChangedEvent>(_onIntChanged);
    on<FileChangedEvent>(_onFileChanged);
    on<SubmittedEvent>(_onSubmitted);
  }

  final List<FileType> _types;

  // Event constants
  static const String fileEvent = "file";
  static const String typeEvent = "type";

  void _onIntChanged(IntChangedEvent event, Emitter<ImportState> emit) {
    var type = event.value;
    emit(
      state.copyWith(type: type, isValid: state.file != null && type > 0),
    );
  }

    void _onFileChanged(FileChangedEvent event, Emitter<ImportState> emit) {
    var file = event.value;
    emit(
      state.copyWith(file: file, isValid: file != null && state.type > 0),
    );
  }

  Future<void> _onSubmitted(SubmittedEvent event, Emitter<ImportState> emit) async {
    if (state.isValid && AppState.metricsLogic != null) {
      emit(state.copyWith(status: SubmissionStatus.inProgress));
      try {
        var file = await state.file?.readAsString();
        await AppState.importLogic?.import(file, state.type);

        event.callback?.call();

        emit(state.copyWith(status: SubmissionStatus.success));
      } catch (ex) {
        emit(state.copyWith(status: SubmissionStatus.failure));
      }
    }
  }
}

final class ImportState {
  const ImportState({
    this.status = SubmissionStatus.initial,
    this.type = 0,
    this.file,
    this.isValid = false,
  });

  final SubmissionStatus status;

  final XFile? file;
  final int type;
  final bool isValid;

  ImportState copyWith({
    SubmissionStatus? status,
    XFile? file,
    int? type,
    bool? isValid, 
  }) {
    return ImportState(
      status: status ?? this.status,
      type: type ?? this.type,
      file: file ?? this.file,
      isValid: isValid ?? this.isValid,
    );
  }
}
