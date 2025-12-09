import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/user_model.dart';

part 'membership_controller.g.dart';

@riverpod
class MembershipController extends _$MembershipController {
  @override
  UserModel? build() {
    return null; // Initial state is null until user is loaded
  }

  void setUser(UserModel user) {
    state = user;
  }

  // Computed state
  bool get isDngEligible {
    final user = state;
    if (user == null) return false;
    return user.newBelieversClass && user.class101 && user.membershipCovenant;
  }

  // Gate check
  bool unlockGate() {
    return isDngEligible;
  }
}
