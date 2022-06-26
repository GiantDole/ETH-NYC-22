import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class DeleteTicketCategoryBloc
    extends DPMutationBloc<DeleteTicketCategory$Mutation> {
  DeleteTicketCategoryBloc({GraphQLClient? client, WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                fetchPolicy: FetchPolicy.noCache,
                document: DELETE_TICKET_CATEGORY_MUTATION_DOCUMENT,
              ),
        );

  @override
  DeleteTicketCategory$Mutation parseData(Map<String, dynamic>? data) {
    return DeleteTicketCategory$Mutation.fromJson(data ?? {});
  }
}
