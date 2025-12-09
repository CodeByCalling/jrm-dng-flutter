import 'package:flutter/foundation.dart';

class MembershipHouseholdMember {
  String name;
  String relationship;
  String age;

  MembershipHouseholdMember({
    this.name = '',
    this.relationship = '',
    this.age = '',
  });
}

class MembershipFormData {
  String fullName;
  String address;
  String contactInfo;
  String spiritualHistory;
  String testimony;
  List<MembershipHouseholdMember> householdMembers;

  MembershipFormData({
    this.fullName = '',
    this.address = '',
    this.contactInfo = '',
    this.spiritualHistory = '',
    this.testimony = '',
    List<MembershipHouseholdMember>? householdMembers,
  }) : householdMembers = householdMembers ?? [];
}
