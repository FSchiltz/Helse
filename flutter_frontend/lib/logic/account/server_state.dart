import 'package:bloc/bloc.dart';
import 'package:helse/services/swagger/generated_code/helseapi.swagger.dart';

class ServerState extends Cubit<Status?> {
  ServerState() : super(null);

  void setStatus(Status? state) {
    emit(state);
  }
}
