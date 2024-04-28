import 'package:helse/services/api_service.dart';

import 'swagger/generated_code/swagger.swagger.dart';

class TreatmentService extends ApiService {
  TreatmentService(super.account);
  
  Future<List<Treatement>?> treatments(DateTime? start, DateTime? end, {int? person}) async {
    var api = await getService();
    return await call(() => api.apiTreatmentGet(start: start, end: end, personId: person));
  }

  Future<void> addTreatment(CreateTreatment treatment) async {
    var api = await getService();
    await call(() => api.apiTreatmentPost(body: treatment));
  }

  Future<List<EventType>?> treatmentTypes() async {
    var api = await getService();
    return await call(api.apiTreatmentTypeGet);
  }
  
}
