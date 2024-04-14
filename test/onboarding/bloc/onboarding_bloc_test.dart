// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notifications_repository/notifications_repository.dart';
import 'package:second/onboarding/onboarding.dart';

class MockNotificationsRepository extends Mock
    implements NotificationsRepository {}

void main() {
  group('OnboardingBloc', () {
    late NotificationsRepository notificationsRepository;

    setUp(() {
      notificationsRepository = MockNotificationsRepository();
    });

    group('EnableNotificationsRequested', () {
      setUp(() {
        when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenAnswer((_) async {});
      });

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingNotifications, EnablingNotificationsSucceeded] '
        'when NotificationsRepository.toggleNotifications succeeds',
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(EnableNotificationsRequested()),
        expect: () => <OnboardingState>[
          EnablingNotifications(),
          EnablingNotificationsSucceeded(),
        ],
        verify: (bloc) => verify(
          () => notificationsRepository.toggleNotifications(enable: true),
        ).called(1),
      );

      blocTest<OnboardingBloc, OnboardingState>(
        'emits '
        '[EnablingNotifications, EnablingNotificationsFailed] '
        'when NotificationsRepository.toggleNotifications fails',
        setUp: () => when(
          () => notificationsRepository.toggleNotifications(
            enable: any(named: 'enable'),
          ),
        ).thenThrow(Exception()),
        build: () => OnboardingBloc(
          notificationsRepository: notificationsRepository,
        ),
        act: (bloc) => bloc.add(EnableNotificationsRequested()),
        expect: () => <OnboardingState>[
          EnablingNotifications(),
          EnablingNotificationsFailed(),
        ],
      );
    });
  });
}
