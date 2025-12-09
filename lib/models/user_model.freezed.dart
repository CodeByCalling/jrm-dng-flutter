// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  String get uid => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;
  String? get dngStatus => throw _privateConstructorUsedError;
  bool get newBelieversClass => throw _privateConstructorUsedError;
  bool get class101 => throw _privateConstructorUsedError;
  bool get membershipCovenant => throw _privateConstructorUsedError;

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    String uid,
    String fullName,
    String? role,
    String? dngStatus,
    bool newBelieversClass,
    bool class101,
    bool membershipCovenant,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? fullName = null,
    Object? role = freezed,
    Object? dngStatus = freezed,
    Object? newBelieversClass = null,
    Object? class101 = null,
    Object? membershipCovenant = null,
  }) {
    return _then(
      _value.copyWith(
            uid: null == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            dngStatus: freezed == dngStatus
                ? _value.dngStatus
                : dngStatus // ignore: cast_nullable_to_non_nullable
                      as String?,
            newBelieversClass: null == newBelieversClass
                ? _value.newBelieversClass
                : newBelieversClass // ignore: cast_nullable_to_non_nullable
                      as bool,
            class101: null == class101
                ? _value.class101
                : class101 // ignore: cast_nullable_to_non_nullable
                      as bool,
            membershipCovenant: null == membershipCovenant
                ? _value.membershipCovenant
                : membershipCovenant // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String uid,
    String fullName,
    String? role,
    String? dngStatus,
    bool newBelieversClass,
    bool class101,
    bool membershipCovenant,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? fullName = null,
    Object? role = freezed,
    Object? dngStatus = freezed,
    Object? newBelieversClass = null,
    Object? class101 = null,
    Object? membershipCovenant = null,
  }) {
    return _then(
      _$UserModelImpl(
        uid: null == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        dngStatus: freezed == dngStatus
            ? _value.dngStatus
            : dngStatus // ignore: cast_nullable_to_non_nullable
                  as String?,
        newBelieversClass: null == newBelieversClass
            ? _value.newBelieversClass
            : newBelieversClass // ignore: cast_nullable_to_non_nullable
                  as bool,
        class101: null == class101
            ? _value.class101
            : class101 // ignore: cast_nullable_to_non_nullable
                  as bool,
        membershipCovenant: null == membershipCovenant
            ? _value.membershipCovenant
            : membershipCovenant // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl({
    required this.uid,
    required this.fullName,
    this.role,
    this.dngStatus,
    this.newBelieversClass = false,
    this.class101 = false,
    this.membershipCovenant = false,
  });

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final String uid;
  @override
  final String fullName;
  @override
  final String? role;
  @override
  final String? dngStatus;
  @override
  @JsonKey()
  final bool newBelieversClass;
  @override
  @JsonKey()
  final bool class101;
  @override
  @JsonKey()
  final bool membershipCovenant;

  @override
  String toString() {
    return 'UserModel(uid: $uid, fullName: $fullName, role: $role, dngStatus: $dngStatus, newBelieversClass: $newBelieversClass, class101: $class101, membershipCovenant: $membershipCovenant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.dngStatus, dngStatus) ||
                other.dngStatus == dngStatus) &&
            (identical(other.newBelieversClass, newBelieversClass) ||
                other.newBelieversClass == newBelieversClass) &&
            (identical(other.class101, class101) ||
                other.class101 == class101) &&
            (identical(other.membershipCovenant, membershipCovenant) ||
                other.membershipCovenant == membershipCovenant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    uid,
    fullName,
    role,
    dngStatus,
    newBelieversClass,
    class101,
    membershipCovenant,
  );

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel({
    required final String uid,
    required final String fullName,
    final String? role,
    final String? dngStatus,
    final bool newBelieversClass,
    final bool class101,
    final bool membershipCovenant,
  }) = _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  String get uid;
  @override
  String get fullName;
  @override
  String? get role;
  @override
  String? get dngStatus;
  @override
  bool get newBelieversClass;
  @override
  bool get class101;
  @override
  bool get membershipCovenant;

  /// Create a copy of UserModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
