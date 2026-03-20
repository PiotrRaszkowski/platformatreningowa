import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platforma_treningowa_mobile/business/health/boundary/health_bloc.dart';
import 'package:platforma_treningowa_mobile/business/health/control/health_repository.dart';
import 'package:platforma_treningowa_mobile/business/health/entity/health_snapshot.dart';

void main() {
  group('HealthBloc', () {
    blocTest<HealthBloc, HealthState>(
      'emits loading and loaded state when started',
      build: () => HealthBloc(const HealthRepository()),
      act: (bloc) => bloc.add(const HealthStarted()),
      expect: () => [
        const HealthState(isLoading: true),
        const HealthState(
          isLoading: false,
          snapshot: HealthSnapshot(
            status: 'Backend gotowy do integracji',
            service: 'platforma-treningowa-backend',
          ),
        ),
      ],
    );
  });
}
