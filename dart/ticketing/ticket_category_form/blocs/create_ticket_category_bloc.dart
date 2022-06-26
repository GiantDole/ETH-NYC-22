import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class CreateTicketCategoryBloc
    extends DPMutationBloc<CreateTicketCategory$Mutation> {
  CreateTicketCategoryBloc({GraphQLClient? client, WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                fetchPolicy: FetchPolicy.networkOnly,
                document: CREATE_TICKET_CATEGORY_MUTATION_DOCUMENT,
              ),
        );

  @override
  CreateTicketCategory$Mutation parseData(Map<String, dynamic>? data) {
    return CreateTicketCategory$Mutation.fromJson(data ?? {});
  }
}
