import '../../enums/admin_approval_status.dart';
import '../org/officer.dart';
import 'user.dart';
import '../../enums/auth_status.dart';
import '../../entities/user/mobile_user.dart';

class MobileUserModel extends MobileUserEntity implements UserModel {
  const MobileUserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.createdAt,
    super.updatedAt,
    super.authStatus,
    super.isArchived,
    super.otp,
    super.otpExpiry,
    super.profileImage,
    required super.mobileUserId,
    required super.officerEntity,
    super.adminApprovalStatus,
  });

  factory MobileUserModel.fromJson(Map<String, dynamic> json) {
    final authStatusString = json['auth_status'] as String;

    // remove the prefix value in enums if present
    final authStatusValue = authStatusString.startsWith('AuthStatus.')
        ? authStatusString.substring(10)
        : authStatusString;

    // extract the last part of the role then compare to the retrieved role String
    final authStatus = AuthStatus.values.firstWhere(
      (e) => e.toString().split('.').last == authStatusValue,
      orElse: () => AuthStatus.unauthenticated,
    );

    final adminApprovalStatus = AdminApprovalStatus.values.firstWhere(
      (e) => e.toString().split('.').last == json['admin_approval_status'],
    );

    final officer = OfficerModel.fromJson(json['officer']);

    return MobileUserModel(
      id: json['user_id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      updatedAt: json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : json['updated_at'],
      authStatus: authStatus,
      isArchived: json['is_archived'],
      otp: json['otp'],
      otpExpiry: json['otp_expiry'] is String
          ? DateTime.parse(json['otp_expiry'] as String)
          : json['otp_expiry'],
      profileImage: json['profile_image'] != null
          ? json['profile_image'] as String
          : null,
      mobileUserId: json['mobile_user_id'],
      officerEntity: officer,
      adminApprovalStatus: adminApprovalStatus,
    );
  }

  factory MobileUserModel.fromEntity(MobileUserEntity mobileUserEntity) {
    return MobileUserModel(
      id: mobileUserEntity.id,
      name: mobileUserEntity.name,
      email: mobileUserEntity.email,
      password: mobileUserEntity.password,
      createdAt: mobileUserEntity.createdAt,
      profileImage: mobileUserEntity.profileImage,
      mobileUserId: mobileUserEntity.mobileUserId,
      officerEntity: mobileUserEntity.officerEntity,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'name': name,
      'email': email,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'auth_status': authStatus,
      'is_archived': isArchived,
      'otp': otp,
      'otp_expiry': otpExpiry,
      'profile_image': profileImage,
      'mobile_user_id': mobileUserId,
      'officer': (officerEntity as OfficerModel).toJson(),
      'admin_approval_status': adminApprovalStatus.toString().split('.').last,
    };
  }
}
