import 'package:bloc/bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ServerStatus {
  final Status? state;
  final bool offline;
  final bool userInitiatedOffline;

  ServerStatus(this.state, this.offline, {this.userInitiatedOffline = false});
}

class ServerState extends Cubit<ServerStatus> {
  ServerState() : super(ServerStatus(null, false));

  bool get isOffline => state.offline;
  bool get isUserInitiatedOffline =>
      state.offline && state.userInitiatedOffline;

  void setStatus(Status? state) {
    emit(ServerStatus(state, false));
  }

  void setOffline({bool userInitiated = false}) {
    emit(
      ServerStatus(
        Status(init: true, externalAuth: false, oauths: []),
        true,
        userInitiatedOffline: userInitiated,
      ),
    );
  }
}
