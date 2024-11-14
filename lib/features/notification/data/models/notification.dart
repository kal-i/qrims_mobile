import '../../../../core/enums/notification_type.dart';
import '../../../../core/models/user/mobile_user.dart';
import '../../../../core/models/user/supply_department_employee.dart';
import '../../../../core/models/user/user.dart';
import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.recipientId,
    required super.sender,
    required super.message,
    super.type,
    super.referenceId,
    required super.read,
    super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final senderMap = json['sender'] as Map<String, dynamic>;
    UserModel sender;

    if (senderMap.containsKey('supp_dept_emp_id')) {
      sender = SupplyDepartmentEmployeeModel.fromJson(senderMap);
    } else {
      sender = MobileUserModel.fromJson(senderMap);
    }

    print('received json: $json');
    final type = NotificationType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'] as String,
    );

    return NotificationModel(
      id: json['notification_id'] as String,
      recipientId: json['recipient_id'] as String,
      sender: sender,
      message: json['message'] as String,
      type: type,
      referenceId: json['reference_id'] as String?,
      read: json['read'] as bool,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
    );
  }
}
