import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_bloc.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_event.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

class ReadTicketingBloc extends DPQueryBloc<Ticketings$Query> {
  final String eventID;
  ReadTicketingBloc(
      {GraphQLClient? client,
      required this.eventID,
      WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                document: TICKETINGS_QUERY_DOCUMENT,
                fetchPolicy: FetchPolicy.noCache,
                //pollInterval: Duration(seconds: 2),
                variables: TicketingsArguments(
                  eventID: eventID,
                  // limit: 25,
                  // offset: 0,
                  // currentDateTime: DateTime.now()
                ).toJson(),
              ),
        );

  @override
  void fetchMore({required int limit, required int offset}) {}

  @override
  Ticketings$Query parseData(Map<String, dynamic>? data) {
    if (data != null) {
      return Ticketings$Query.fromJson(data);
    }
    return Ticketings$Query();
  }
}
