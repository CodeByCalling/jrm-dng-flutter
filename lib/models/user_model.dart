import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
sealed class UserModel with _$UserModel {
  const factory UserModel({
    required String uid,
    required String fullName,
    String? role,
    String? dngStatus,
    @Default(false) bool newBelieversClass,
    @Default(false) bool class101,
    @Default(false) bool membershipCovenant,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
