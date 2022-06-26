import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:dashpoint/core_components/dp_alert/dp_alert.dart';
import 'package:dashpoint/core_components/dp_secondary_button/dp_secondary_button.dart';
import 'package:dashpoint/graphql/requests.graphql_api.graphql.dart';

import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_state.dart';
import 'package:dashpoint/core_components/dp_primary_button/dp_primary_button.dart';
import 'package:dashpoint/pages/ticketing/event_ticketing_page_bloc.dart';
import 'package:dashpoint/pages/ticketing/ticket_purchase/paynl_checkout_page.dart';
import 'package:dashpoint/pages/ticketing/ticket_purchase/ticket_purchase_bottom_sheet_cubit.dart';
import 'package:dashpoint/pages/ticketing/ticket_purchase/ticket_purchase_cubit.dart';
import 'package:dashpoint/core/design/app_color.dart';

import 'package:dashpoint/core/design/icons/dashpoint_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dashpoint/routes/router.gr.dart';
import 'package:url_launcher/url_launcher.dart' as urll;

import 'package:sliding_up_panel/sliding_up_panel.dart';

class TicketPurchaseBottomSheet extends StatelessWidget {
  String eventID;
  TicketPurchaseBottomSheet(this.eventID);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TicketPurchaseBottomSheetCubit()),
        BlocProvider<TicketPurchaseCubit>(
            create: (context) => TicketPurchaseCubit()),
      ],
      child: BlocBuilder<TicketPurchaseBottomSheetCubit,
          TicketPurchaseBottomSheetState>(
        builder: (context, panelState) {
          return BlocBuilder<EventTicketingPageBloc,
                  DPQueryState<EventTickets$Query>>(
              bloc: EventTicketingPageBloc(eventID: eventID)..run(),
              builder: (context, ticketingState) {
                if (ticketingState.data != null)
                  context
                      .read<TicketPurchaseCubit>()
                      .initialized(ticketingState.data!.ticketCategories);
                int ticketAmount = ticketingState.data != null
                    ? ticketingState.data!.ticketCategories.length
                    : 0;
                return BlocBuilder<TicketPurchaseCubit, TicketPurchaseState>(
                    buildWhen: (p, c) =>
                        p.selectedTicketCategoryIndex !=
                        c.selectedTicketCategoryIndex,
                    builder: (context, ticketPurchaseState) {
                      double bottomSheetHeight =
                          (370 + 60 * ticketAmount).toDouble() > 950
                              ? 950
                              : (370 + 60 * ticketAmount).toDouble();
                      return Stack(
                        children: [
                          purchaseButton(context, ticketPurchaseState),
                          SlidingUpPanel(
                            color: Colors.green,
                            snapPoint: 0.7,
                            backdropEnabled: true,
                            minHeight: 0,
                            maxHeight: bottomSheetHeight,
                            controller: panelState.panelController,
                            isDraggable: false,
                            panel: ticketPurchaseBottomSheet(context,
                                panelState.panelController, ticketingState),
                            // collapsed: purchaseButton(context),
                            // borderRadius: ,
                          ),
                        ],
                      );
                    });
              });
        },
      ),
    );
  }

  Widget purchaseButton(
      BuildContext context, TicketPurchaseState ticketPurchaseState) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 80,
        color: Theme.of(context).dialogBackgroundColor,
        child: Container(
          padding: EdgeInsets.all(16),
          child: DPPrimaryButton(
            cornerRadius: 16,
            onPressed: () {
              ticketPurchaseState.selectedTicketCategoryIndex != -1
                  ? context
                      .read<TicketPurchaseBottomSheetCubit>()
                      .showCheckoutMenu()
                  : context
                      .read<TicketPurchaseBottomSheetCubit>()
                      .showTicketCategoryPage();
              // showTickets(context, event);
              //TODO move bottomsheet up
            },
            text: 'Buy Ticket',
          ),
        ),
      ),
    );
  }

  Widget checkoutMenu(
      BuildContext context, DPQueryState<EventTickets$Query> ticketingState) {
    return BlocBuilder<TicketPurchaseCubit, TicketPurchaseState>(
      builder: (context, ticketPurchaseState) {
        EventTickets$Query$TicketCategories selectedTicketCategory =
            ticketingState.data!.ticketCategories
                .elementAt(ticketPurchaseState.selectedTicketCategoryIndex);
        bool isExpired =
            selectedTicketCategory.endSales.isBefore(DateTime.now());
        bool isInFuture =
            selectedTicketCategory.startSales.isAfter(DateTime.now());

        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 320,
            color: Theme.of(context).dialogBackgroundColor,
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: ticketPurchaseState.maxTicketReached
                        ? Text(
                            "You have reached the limit of 5 tickets",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Theme.of(context).errorColor),
                          )
                        : isExpired
                            ? Text(
                                "The ticket sale has ended",
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : isInFuture
                                ? Text(
                                    "Sale Starts: " +
                                        createEndSalesDate(
                                            selectedTicketCategory.startSales),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  )
                                : Text(
                                    "Sale End: " +
                                        createEndSalesDate(
                                            selectedTicketCategory.endSales),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: DPSecondaryButton(
                          context,
                          text: "-",
                          onPressed: () {
                            if (!isInFuture && !isExpired)
                              context
                                  .read<TicketPurchaseCubit>()
                                  .removeTicketCategory(ticketPurchaseState
                                      .selectedTicketCategoryIndex);
                          },
                          buttonWidth: 40,
                          buttonHeight: 40,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        ticketPurchaseState.ticketsPurchased[
                                ticketPurchaseState.selectedTicketCategoryIndex]
                            .toString(),
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 45),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: DPSecondaryButton(
                          context,
                          text: "+",
                          onPressed: () {
                            if (!isInFuture && !isExpired)
                              context
                                  .read<TicketPurchaseCubit>()
                                  .addTicketCategory(ticketPurchaseState
                                      .selectedTicketCategoryIndex);
                          },
                          buttonWidth: 40,
                          buttonHeight: 40,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOTAL:",
                        style: Theme.of(context)
                            .textTheme
                            .headline2!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Text(
                          ticketPurchaseState.sumOfPurchase.toString() + " EUR",
                          style: Theme.of(context).textTheme.headline2!),
                    ],
                  ),
                  Divider(),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "By continuing you agree to our terms and conditions",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 12),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DPPrimaryButton(
                    onPressed: () {
                      if (ticketPurchaseState.sumOfPurchase > 0) {
                        // context.router.push(PaynlCheckoutPageRoute());
                        saveItem(context);
                      }
                    },
                    text: 'Checkout',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> saveItem(BuildContext context) async {
    
    urll.launch(transactionLink}

  Widget ticketPurchaseBottomSheet(
      BuildContext context,
      PanelController controller,
      DPQueryState<EventTickets$Query> ticketingState) {
    if (ticketingState.data != null)
      return BlocBuilder<TicketPurchaseCubit, TicketPurchaseState>(
          builder: (context, ticketPurchaseState) {
        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    height: 600,
                    color: Theme.of(context).backgroundColor,
                    child: ListView(
                      children: [
                        Stack(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Center(
                              child: Text(
                                "Select your Tickets",
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ticketCategoryList(
                            context, ticketingState, ticketPurchaseState),
                        if (ticketPurchaseState.selectedTicketCategoryIndex !=
                            -1) ...[
                          SizedBox(
                            height: 300,
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.topLeft,
              child: InkWell(
                onTap: () => controller.close(),
                child: Icon(
                  DashpointIcons.cancel,
                  // color: Theme.of(context).dialogBackgroundColor,
                ),
              ),
            ),
            if (ticketPurchaseState.selectedTicketCategoryIndex != -1)
              checkoutMenu(context, ticketingState)
          ],
        );
      });
    else
      return Container(); //TODO 'tickets avaialblet soon'
  }

  Widget ticketCategoryList(
    BuildContext context,
    DPQueryState<EventTickets$Query> ticketingState,
    TicketPurchaseState ticketPurchaseState,
  ) {
    // TODO ticket experied, ticket in future, ticket selected
    return Container(
      width: double.infinity,
      child: Column(
          children:
              ticketingState.data!.ticketCategories.map((ticketCategoryData) {
        bool isSelectedTicket =
            ticketingState.data!.ticketCategories.indexOf(ticketCategoryData) ==
                ticketPurchaseState.selectedTicketCategoryIndex;

        return ticketCategoryCard(context, ticketingState, ticketPurchaseState,
            isSelectedTicket, ticketCategoryData);
      }).toList()),
    );
  }

  Widget ticketCategoryCard(
      BuildContext context,
      DPQueryState<EventTickets$Query> ticketingState,
      TicketPurchaseState ticketPurchaseState,
      bool isSelectedTicket,
      EventTickets$Query$TicketCategories ticketCategoryData) {
    bool isExpired = ticketCategoryData.endSales.isBefore(DateTime.now());
    bool isInFuture = ticketCategoryData.startSales.isAfter(DateTime.now());

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          context.read<TicketPurchaseCubit>().selectTicketCategory(
              ticketingState.data!.ticketCategories
                  .indexOf(ticketCategoryData));
          context.read<TicketPurchaseBottomSheetCubit>().showCheckoutMenu();
        },
        child: Container(
          width: double.infinity,
          // height: 80,

          decoration: BoxDecoration(
              color: isSelectedTicket
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              border: Border.all(color: AppColor.grey),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ticketCategoryName(
                  context, ticketCategoryData.name, isExpired, isInFuture),
              Text(
                ticketCategoryData.ticketPrice
                        .toStringAsFixed(2)
                        .replaceAll('.', ',') +
                    " €",
                style: isExpired || isInFuture
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context).textTheme.headline5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ticketCategoryName(BuildContext context, String ticketName,
      bool isExpired, bool isInFuture) {
    List<String> ticketNameWords = ticketName.split(" ");
    String line1 = "";
    String line2 = "";

    int MAX_CHARACTERS_PER_LINE = 20;
    bool writeLine2 = false;

    for (String word in ticketNameWords) {
      if (line1.length + word.length < MAX_CHARACTERS_PER_LINE && !writeLine2) {
        line1 += word + " ";
      } else if (line2.length + word.length < MAX_CHARACTERS_PER_LINE) {
        writeLine2 = true;
        line2 += word + " ";
      } else {
        line2 += "...";
        break;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          line1,
          style: isExpired
              ? Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(decoration: TextDecoration.lineThrough)
              : isInFuture
                  ? Theme.of(context).textTheme.bodyText1!
                  : Theme.of(context).textTheme.headline5!,
        ),
        line2 != ""
            ? Text(
                line2,
                style: isExpired
                    ? Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(decoration: TextDecoration.lineThrough)
                    : isInFuture
                        ? Theme.of(context).textTheme.bodyText1!
                        : Theme.of(context).textTheme.headline5!,
              )
            : Container(),
      ],
    );
  }

  String createEndSalesDate(DateTime endTime) {
    String weekDay = DateFormat('E').format(endTime);
    String day = DateFormat.d().format(endTime);
    String month = DateFormat.MMM().format(endTime);
    String time = DateFormat.Hm().format(endTime);
    // String timeZone = DateFormat("z").format(endTime); // unimplemented yet

    return weekDay + ". " + day + ". " + month + " " + time;
  }
}
