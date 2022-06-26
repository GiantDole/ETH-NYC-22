import 'package:dashpoint/graphql/requests.graphql_api.graphql.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

part 'ticket_purchase_bottom_sheet_cubit.freezed.dart';

@freezed
class TicketPurchaseBottomSheetState with _$TicketPurchaseBottomSheetState {
  const factory TicketPurchaseBottomSheetState({
    required PanelController panelController,
    required bool panelListener,
  }) = _TicketPurchaseBottomSheetState;

  factory TicketPurchaseBottomSheetState.initial() =>
      TicketPurchaseBottomSheetState(
        panelController: new PanelController(),
        panelListener: false,
      );
}

class TicketPurchaseBottomSheetCubit
    extends Cubit<TicketPurchaseBottomSheetState> {
  TicketPurchaseBottomSheetCubit()
      : super(TicketPurchaseBottomSheetState.initial());

  void showTicketCategoryPage() {
    state.panelController.animatePanelToSnapPoint();
    // emit(state.copyWith(panelListener: !state.panelListener));
  }

  void showCheckoutMenu() {
    state.panelController.open();
    // emit(state.copyWith(panelListener: !state.panelListener));
  }

  void closeTicketCategoryPage() {
    state.panelController.close();
    // emit(state.copyWith(panelListener: !state.panelListener));
  }
}
