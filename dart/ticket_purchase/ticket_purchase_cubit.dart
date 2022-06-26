import 'package:dashpoint/graphql/requests.graphql_api.graphql.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_purchase_cubit.freezed.dart';

@freezed
class TicketPurchaseState with _$TicketPurchaseState {
  const factory TicketPurchaseState({
    required List<int> ticketsPurchased,
    required int selectedTicketCategoryIndex,
    required List<EventTickets$Query$TicketCategories> ticketCategories,
    required double sumOfPurchase,
    required bool maxTicketReached,
  }) = _TicketPurchaseState;

  factory TicketPurchaseState.initial() => TicketPurchaseState(
        ticketsPurchased: [],
        ticketCategories: [],
        sumOfPurchase: 0,
        selectedTicketCategoryIndex: -1,
        maxTicketReached: false,
      );
}

class TicketPurchaseCubit extends Cubit<TicketPurchaseState> {
  final int MAX_NUMBER_OF_TICKETS = 5;

  TicketPurchaseCubit() : super(TicketPurchaseState.initial());

  void initialized(
      List<EventTickets$Query$TicketCategories> ticketCategories) async {
    emit(state.copyWith(
      ticketsPurchased: List.generate(ticketCategories.length, (index) => 0),
      ticketCategories: ticketCategories,
    ));
  }

  void addTicketCategory(int index) async {
    int sumOfTickets = getSumOfTickets(state);

    if (sumOfTickets < MAX_NUMBER_OF_TICKETS) {
      List<int> newTicketsPurchased = state.ticketsPurchased;
      newTicketsPurchased[index] = newTicketsPurchased[index] + 1;
      bool maxTicketReached = false;
      if (sumOfTickets == MAX_NUMBER_OF_TICKETS - 1) {
        maxTicketReached = true;
      }

      emit(state.copyWith(
          maxTicketReached: maxTicketReached,
          ticketsPurchased: newTicketsPurchased,
          sumOfPurchase:
              state.sumOfPurchase + state.ticketCategories[index].ticketPrice));
    }
  }

  void selectTicketCategory(int index) async {
    emit(state.copyWith(selectedTicketCategoryIndex: index));
  }

  void removeTicketCategory(int index) async {
    if (state.ticketsPurchased[index] > 0) {
      List<int> newTicketsPurchased = state.ticketsPurchased;
      newTicketsPurchased[index] = newTicketsPurchased[index] - 1;
      bool maxTicketReached = false;

      emit(state.copyWith(
          maxTicketReached: false,
          ticketsPurchased: newTicketsPurchased,
          sumOfPurchase:
              state.sumOfPurchase - state.ticketCategories[index].ticketPrice));
    }
  }

  int getSumOfTickets(TicketPurchaseState state) {
    int sum = 0;
    state.ticketsPurchased.forEach((element) {
      sum += element;
    });
    return sum;
  }
}
