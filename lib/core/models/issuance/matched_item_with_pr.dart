import '../../entities/issuance/matched_item_with_pr.dart';
import '../purchase_request/purchase_request.dart';
import 'matched_item.dart';

class MatchedItemWithPrModel extends MatchedItemWithPrEntity {
  const MatchedItemWithPrModel({
    required super.purchaseRequestEntity,
    super.matchedItemEntity,
  });

  factory MatchedItemWithPrModel.fromJson(Map<String, dynamic> json) {
    final purchaseRequest = PurchaseRequestModel.fromJson(json['purchase_request']);
    final matchedItems = (json['matched_items'] as List)
        .map((itemJson) => MatchedItemModel.fromJson(itemJson))
        .toList();


    return MatchedItemWithPrModel(
      purchaseRequestEntity: purchaseRequest,
      matchedItemEntity: matchedItems,
    );
  }
}
