import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../entities/issuance/issuance.dart';
import '../../domain/usecases/get_issuance_by_id.dart';

part 'issuance_events.dart';
part 'issuance_states.dart';

class IssuancesBloc extends Bloc<IssuancesEvent, IssuancesState> {
  IssuancesBloc({
    required GetIssuanceById getIssuanceById,
  })  : _getIssuanceById = getIssuanceById,
        super(IssuancesInitial()) {
    on<GetIssuanceByIdEvent>(_onGetIssuanceByIdEvent);
  }

  final GetIssuanceById _getIssuanceById; 

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
}
