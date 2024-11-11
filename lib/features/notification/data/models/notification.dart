import '../../../../core/enums/notification_type.dart';
import '../../domain/entities/notification.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.recipientId,
    required super.senderId,
    required super.message,
    super.type,
    super.referenceId,
    required super.read,
    super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    print('received json: $json');
    final type = NotificationType.values.firstWhere(
      (e) => e.toString().split('.').last == json['type'] as String,
    );

    return NotificationModel(
      id: json['notification_id'] as String,
      recipientId: json['recipient_id'] as String,
      senderId: json['sender_id'] as String,
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
