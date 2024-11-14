import 'package:equatable/equatable.dart';

import '../../../../core/entities/item_inventory/product_description.dart';
import '../../../../core/entities/item_inventory/product_name.dart';
import '../../../../core/entities/org/office.dart';
import '../../../../core/entities/org/officer.dart';
import '../../../../core/enums/fund_cluster.dart';
import '../../../../core/enums/purchase_request_status.dart';
import '../../../../core/enums/unit.dart';
import 'entity.dart';

class PurchaseRequestEntity extends Equatable {
  const PurchaseRequestEntity({
    required this.id,
    required this.entity,
    required this.fundCluster,
    required this.officeEntity,
    this.responsibilityCenterCode,
    required this.date,
    required this.productNameEntity,
    required this.productDescriptionEntity,
    required this.unit,
    required this.quantity,
    this.remainingQuantity,
    required this.unitCost,
    required this.totalCost,
    required this.purpose,
    required this.requestingOfficerEntity,
    required this.approvingOfficerEntity,
    this.purchaseRequestStatus = PurchaseRequestStatus.pending,
    this.isArchived = false,
  });

  final String id;
  final Entity entity;
  final FundCluster fundCluster;
  final OfficeEntity officeEntity;
  final String? responsibilityCenterCode;
  final DateTime date;
  final ProductNameEntity productNameEntity;
  final ProductDescriptionEntity productDescriptionEntity;
  final Unit unit;
  final int quantity;
  final int? remainingQuantity; // to track if qty not yet fulfilled
  final double unitCost;
  final double totalCost;
  final String purpose;
  final OfficerEntity requestingOfficerEntity;
  final OfficerEntity approvingOfficerEntity;
  final PurchaseRequestStatus purchaseRequestStatus;
  final bool? isArchived;

  @override
  List<Object?> get props => [
    id,
    entity,
    fundCluster,
    officeEntity,
    responsibilityCenterCode,
    date,
    productNameEntity,
    productDescriptionEntity,
    unit,
    quantity,
    remainingQuantity,
    unitCost,
    totalCost,
    purpose,
    requestingOfficerEntity,
    approvingOfficerEntity,
    purchaseRequestStatus,
    isArchived,
  ];
}