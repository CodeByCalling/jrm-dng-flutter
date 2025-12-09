import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrm_dng_flutter/controllers/membership_controller.dart';
import 'package:jrm_dng_flutter/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

void main() {
  test('MembershipController initial state is null', () {
    final container = ProviderContainer();
    final controller = container.read(membershipControllerProvider);
    expect(controller, isNull);
  });

  test('MembershipController isDngEligible returns false if user is null', () {
    final container = ProviderContainer();
    // We need to access the notifier to check the computed property on the class instance
    // But since it's a synchronous build returning UserModel?, the provider exposes the state directly.
    // The class methods are on the notifier.
    final notifier = container.read(membershipControllerProvider.notifier);
    
    // Initial state is null
    expect(notifier.isDngEligible, isFalse);
    expect(notifier.unlockGate(), isFalse);
  });

  test('MembershipController isDngEligible returns false if requirements not met', () {
    final container = ProviderContainer();
    final notifier = container.read(membershipControllerProvider.notifier);

    notifier.setUser(const UserModel(
      uid: '1',
      fullName: 'Test User',
      newBelieversClass: true,
      class101: false, // Missing
      membershipCovenant: true,
    ));

    expect(notifier.isDngEligible, isFalse);
    expect(notifier.unlockGate(), isFalse);
  });

  test('MembershipController isDngEligible returns true if all requirements met', () {
    final container = ProviderContainer();
    final notifier = container.read(membershipControllerProvider.notifier);

    notifier.setUser(const UserModel(
      uid: '2',
      fullName: 'Eligible User',
      newBelieversClass: true,
      class101: true,
      membershipCovenant: true,
    ));

    expect(notifier.isDngEligible, isTrue);
    expect(notifier.unlockGate(), isTrue);
  });
}
