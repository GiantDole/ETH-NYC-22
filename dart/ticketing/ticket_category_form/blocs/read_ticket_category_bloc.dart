import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_bloc.dart';

import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ReadTicketCategoryBloc
    extends DPQueryBloc<ReadTicketCategoryAdmin$Query> {
  final String ticketCategoryID;
  ReadTicketCategoryBloc(
      {required GraphQLClient client,
      required this.ticketCategoryID,
      WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                document: READ_TICKET_CATEGORY_ADMIN_QUERY_DOCUMENT,
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                variables: ReadTicketCategoryAdminArguments(
                  ticketCategoryID: ticketCategoryID,
                ).toJson(),
              ),
        );

  @override
  ReadTicketCategoryAdmin$Query parseData(Map<String, dynamic>? data) {
    if (data != null) {
      return ReadTicketCategoryAdmin$Query.fromJson(data);
    }
    return ReadTicketCategoryAdmin$Query();
  }

  @override
  void fetchMore({required int limit, required int offset}) {
    // TODO: implement fetchMore
  }
}
