// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      fullName: json['fullName'] as String,
      role: json['role'] as String?,
      dngStatus: json['dngStatus'] as String?,
      newBelieversClass: json['newBelieversClass'] as bool? ?? false,
      class101: json['class101'] as bool? ?? false,
      membershipCovenant: json['membershipCovenant'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'fullName': instance.fullName,
      'role': instance.role,
      'dngStatus': instance.dngStatus,
      'newBelieversClass': instance.newBelieversClass,
      'class101': instance.class101,
      'membershipCovenant': instance.membershipCovenant,
    };
