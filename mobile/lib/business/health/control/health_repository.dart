import '../entity/health_snapshot.dart';

class HealthRepository {
  const HealthRepository();

  Future<HealthSnapshot> fetchHealth() async {
    return const HealthSnapshot(
      status: 'Backend gotowy do integracji',
      service: 'platforma-treningowa-backend',
    );
  }
}
