import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class UpdateTicketCategoryBloc
    extends DPMutationBloc<UpdateTicketCategory$Mutation> {
  UpdateTicketCategoryBloc({GraphQLClient? client, WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                fetchPolicy: FetchPolicy.noCache,
                document: UPDATE_TICKET_CATEGORY_MUTATION_DOCUMENT,
              ),
        );

  @override
  UpdateTicketCategory$Mutation parseData(Map<String, dynamic>? data) {
    return UpdateTicketCategory$Mutation.fromJson(data ?? {});
  }
}
