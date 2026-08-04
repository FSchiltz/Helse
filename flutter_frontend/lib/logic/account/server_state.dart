import 'package:bloc/bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ServerStatus {
  final Status? state;
  final bool offline;

  ServerStatus(this.state, this.offline);
}

class ServerState extends Cubit<ServerStatus> {
  ServerState() : super(ServerStatus(null, false));

  bool get isOffline => state.offline;

  void setStatus(Status? state) {
    emit(ServerStatus(state, false));
  }

  void setOffline() {
    emit(
      ServerStatus(Status(init: true, externalAuth: false, oauths: []), true),
    );
  }
}
