import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../entities/issuance/issuance.dart';
import '../../domain/usecases/get_issuance_by_id.dart';
import '../../domain/usecases/receive_issuance.dart';

part 'issuance_events.dart';
part 'issuance_states.dart';

class IssuancesBloc extends Bloc<IssuancesEvent, IssuancesState> {
  IssuancesBloc({
    required GetIssuanceById getIssuanceById,
    required ReceiveIssuance receiveIssuance,
  })  : _getIssuanceById = getIssuanceById,
        _receiveIssuance = receiveIssuance,
        super(IssuancesInitial()) {
    on<GetIssuanceByIdEvent>(_onGetIssuanceByIdEvent);
    on<ReceiveIssuanceEvent>(_onReceiveIssuance);
  }

  final GetIssuanceById _getIssuanceById;
  final ReceiveIssuance _receiveIssuance;

  void _onGetIssuanceByIdEvent(
    GetIssuanceByIdEvent event,
    Emitter<IssuancesState> emit,
  ) async {
    emit(IssuancesLoading());

    final response = await _getIssuanceById(event.id);

    response.fold(
      (l) => emit(
        IssuancesError(message: l.message),
      ),
      (r) => emit(
        IssuanceLoaded(
          issuance: r!,
        ),
      ),
    );
  }

  void _onReceiveIssuance(
    ReceiveIssuanceEvent event,
    Emitter<IssuancesState> emit,
  ) async {
    emit(ReceivingIssuanceLoading());

    final response = await _receiveIssuance(
      event.id,
    );

    response.fold(
      (l) => emit(
        ReceiveIssuanceError(message: l.message),
      ),
      (r) => emit(
        ReceivedIssuance(
          issuance: r!,
        ),
      ),
    );
  }
}
