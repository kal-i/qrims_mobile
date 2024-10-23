import 'package:equatable/equatable.dart';

class PositionEntity extends Equatable {
  const PositionEntity({
    required this.id,
    required this.officeId,
    required this.positionName,
  });

  final String id;
  final String officeId;
  final String positionName;

  @override
  List<Object?> get props => [
        id,
        officeId,
        positionName,
      ];
}
