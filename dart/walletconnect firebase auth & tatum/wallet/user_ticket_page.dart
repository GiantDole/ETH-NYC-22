import 'package:dashpoint/core_components/dp_app_bar/dp_app_bar.dart';
import 'package:dashpoint/core_components/dp_scaffold/dp_scaffold.dart';
import 'package:dashpoint/feature_components/ticketing/ticket_detail_card.dart';
import 'package:dashpoint/graphql/requests.graphql_api.graphql.dart';
import 'package:flutter/material.dart';

class UserTicketPage extends StatelessWidget {
  final TicketCardMixin ticket;

  UserTicketPage({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return DPScaffold.pushAndAuthListener(
        appBar: DPAppBar(
          context: context,
          title: "Event ticket",
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showUserAvatar: false,
        ),
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        context: context,
        body: buildBody(context));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TicketDetailCard(
            ticket: ticket,
          ),
        ],
      ),
    );
  }
}
