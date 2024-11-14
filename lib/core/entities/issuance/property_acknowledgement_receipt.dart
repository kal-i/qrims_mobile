import '../org/officer.dart';
import 'issuance.dart';

class PropertyAcknowledgementReceiptEntity extends IssuanceEntity {
  const PropertyAcknowledgementReceiptEntity({
    required super.id,
    required this.parId,
    this.propertyNumber,
    required super.items,
    required super.purchaseRequestEntity,
    required super.issuedDate,
    super.returnDate,
    required super.receivingOfficerEntity,
    required this.sendingOfficerEntity,
    required super.qrCodeImageData,
    super.isReceived,
    super.isArchived,
  });

  final String parId;
  final String? propertyNumber;
  final OfficerEntity sendingOfficerEntity;
}
