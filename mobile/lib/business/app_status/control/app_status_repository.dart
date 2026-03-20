import '../entity/app_status_state.dart';

class AppStatusRepository {
  Future<AppStatusValue> checkStatus() async {
    // In a real app this would call the backend /api/health endpoint
    return AppStatusValue.online;
  }
}
