import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platformatreningowa/business/app_status/boundary/app_status_bloc.dart';
import 'package:platformatreningowa/business/app_status/control/app_status_repository.dart';
import 'package:platformatreningowa/business/app_status/entity/app_status_event.dart';
import 'package:platformatreningowa/business/app_status/entity/app_status_state.dart';

class MockAppStatusRepository extends Mock implements AppStatusRepository {}

void main() {
  late MockAppStatusRepository repository;

  setUp(() {
    repository = MockAppStatusRepository();
  });

  group('AppStatusBloc', () {
    test('initial state is unknown', () {
      final bloc = AppStatusBloc(repository: repository);
      expect(bloc.state, const AppStatusState());
      expect(bloc.state.status, AppStatusValue.unknown);
      bloc.close();
    });

    blocTest<AppStatusBloc, AppStatusState>(
      'emits online when repository returns online',
      build: () {
        when(() => repository.checkStatus())
            .thenAnswer((_) async => AppStatusValue.online);
        return AppStatusBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const AppStatusRequested()),
      expect: () => [
        const AppStatusState(status: AppStatusValue.online),
      ],
    );

    blocTest<AppStatusBloc, AppStatusState>(
      'emits offline when repository throws',
      build: () {
        when(() => repository.checkStatus()).thenThrow(Exception('no network'));
        return AppStatusBloc(repository: repository);
      },
      act: (bloc) => bloc.add(const AppStatusRequested()),
      expect: () => [
        const AppStatusState(status: AppStatusValue.offline),
      ],
    );
  });
}
