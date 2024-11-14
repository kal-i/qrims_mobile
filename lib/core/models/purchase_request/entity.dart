import '../../entities/purchase_request/entity.dart';

class EntityModel extends Entity {
  const EntityModel({
    required super.id,
    required super.name,
  });

  factory EntityModel.fromJson(Map<String, dynamic> json) {
    return EntityModel(
      id: json['entity_id'] as String,
      name: json['entity_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entity_id': id,
      'entity_name': name,
    };
  }
}