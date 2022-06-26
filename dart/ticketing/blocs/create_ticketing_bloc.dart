import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_bloc.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter_bloc/graphql_flutter_bloc.dart';

class CreateTicketingBloc extends DPMutationBloc<CreateTicketing$Mutation> {
  CreateTicketingBloc({GraphQLClient? client, WatchQueryOptions? options})
      : super(
          options: options ??
              WatchQueryOptions(
                fetchPolicy: FetchPolicy.networkOnly,
                document: CREATE_TICKETING_MUTATION_DOCUMENT,
              ),
        );

  @override
  CreateTicketing$Mutation parseData(Map<String, dynamic>? data) {
    return CreateTicketing$Mutation.fromJson(data ?? {});
  }
}
