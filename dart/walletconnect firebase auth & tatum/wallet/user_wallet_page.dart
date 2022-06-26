import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dashpoint/core/auth/auth_bloc/auth_bloc.dart';
import 'package:dashpoint/core/wallet_connect/wallet_connect_bloc/wallet_connect_bloc.dart';
import 'package:dashpoint/core_components/dp_app_bar/dp_app_bar.dart';
import 'package:dashpoint/core_components/dp_list_view/dp_list_view_query.dart';
import 'package:dashpoint/core_components/dp_news/dp_loading_news_card.dart';
import 'package:dashpoint/core_components/dp_scaffold/dp_scaffold.dart';
import 'package:dashpoint/core_components/dp_secondary_button/dp_secondary_button.dart';
import 'package:dashpoint/feature_components/ticketing/ticket_card.dart';
import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/injection.dart';
import 'package:dashpoint/pages/user_menu/wallet/wallet_design/swipercard.dart';
import 'package:dashpoint/pages/user_menu/wallet/wallet_design/widgeticons.dart';
import 'package:dashpoint/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserWalletPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DPScaffold.pushAndAuthListener(
        appBar: DPAppBar(
          context: context,
          title: "Ticket wallet",
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showUserAvatar: true,
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        context: context,
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: SafeArea(
        child: SizedBox(
          width: we,
          height: he,
          child: Column(
            children: <Widget>[
              const Swipercard(), // cards ..
              // Icons custom button //
              Text(
                "Your current NFT-Tickets",
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: he * 0.02,
              ),
              Container(
                child: buildTicketList(),
                padding: EdgeInsets.all(16),
              ),
            ],
          ),
        ),
      ),
    );
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildWalletInfo(context),
          Text(
            "Your current NFT-Tickets",
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(height: 32),
          buildTicketList(),
        ],
      ),
    );
  }

  Widget buildWalletInfo(BuildContext context) {
    return BlocBuilder<WalletConnectBloc, WalletConnectState>(
      bloc: getIt<WalletConnectBloc>(),
      builder: (context, state) {
        return Column(
          children: [
            AutoSizeText(
              state.selectedWalletAddress.toString(),
              maxLines: 1,
            ),
            Text("Chain: " + state.chainID.toString()),
            Text("Connected: " + state.connected.toString()),
            if (state.connected) ...[
              DPSecondaryButton(context,
                  buttonWidth: 400,
                  text: "Disconnect",
                  onPressed: () => getIt<WalletConnectBloc>()
                      .add(WalletConnectEvent.createSession())),
            ],
            if (!state.connected) ...[
              DPSecondaryButton(context,
                  buttonWidth: 400,
                  text: "Connect Wallet with WalletConnect",
                  onPressed: () => getIt<WalletConnectBloc>()
                      .add(WalletConnectEvent.createSession())),
            ]
          ],
        );
      },
    );
  }

  Widget buildTicketList() {
    return DPListViewQuery<UserTickets$Query, UserTickets$Query$Tickets>(
      emptyBuilder: (BuildContext context) {
        return Container();
      },
      listItemBuilder: (context, data, bloc) => TicketCard(
        ticket: data,
        onTap: () => context.router.push(UserTicketPageRoute(ticket: data)),
      ),
      loadingCardBuilder: (c) => DPLoadingNewsCard(
        hasPicture: true,
      ),
      listFromData: (UserTickets$Query data) => data.tickets,
      readDocument: USER_TICKETS_QUERY_DOCUMENT,
      readArgsBuilder: () => UserTicketsArguments(
        userID: getIt<AuthBloc>().state.userID ?? "No ID",
      ).toJson(),
      parseReadQueryDataFromJson: (data) {
        if (data != null) {
          return UserTickets$Query.fromJson(data);
        }
        return UserTickets$Query();
      },
    );
  }
}
