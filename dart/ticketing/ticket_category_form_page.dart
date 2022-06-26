import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:url_launcher/url_launcher.dart' as urll;

import 'package:dashpoint/core/auth/auth_bloc/auth_bloc.dart';
import 'package:dashpoint/core/design/app_typography.dart';
import 'package:dashpoint/core/nftport/repository.dart';
import 'package:dashpoint/core_components/dp_alert/dp_alert.dart';
import 'package:dashpoint/core_components/dp_form_fields/image/dp_image.dart';
import 'package:dashpoint/core_components/dp_form_fields/image/dp_image_form_field.dart';
import 'package:dashpoint/core_components/dp_secondary_button/dp_secondary_button.dart';
import 'package:dashpoint/generated/l10n.dart';
import 'package:dashpoint/graphql/graphql_client.dart';
import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_state.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_state.dart';
import 'package:dashpoint/core_components/dp_app_bar/dp_app_bar.dart';
import 'package:dashpoint/core_components/dp_form_fields/date_time/dp_date_time_form_field.dart';
import 'package:dashpoint/core_components/dp_form_fields/text/dp_text_form_field.dart';
import 'package:dashpoint/core_components/dp_scaffold/dp_scaffold.dart';
import 'package:dashpoint/core_components/failure/failure_display.dart';
import 'package:dashpoint/pages/event_main/admin/ticketing/ticket_category_form/blocs/delete_ticket_category_bloc.dart';
import 'package:dashpoint/pages/event_main/admin/ticketing/ticket_category_form/blocs/read_ticket_category_bloc.dart';
import 'package:dashpoint/core/design/app_color.dart';

import 'package:dashpoint/core_components/dp_date_converter/dp-date_converter.dart';

import 'package:dashpoint/core/design/icons/dashpoint_icons.dart';

import 'package:dashpoint/core_components/dp_will_pop_adction/dp_will_pop_action.dart';

import 'package:dashpoint/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../../constants.dart';
import '../../../../../../../../injection.dart';
import 'blocs/create_ticket_category_bloc.dart';
import 'blocs/update_ticket_category_bloc.dart';

class TicketCategoryForm extends StatelessWidget implements AutoRouteWrapper {
  final String? ticketCategoryID;
  final String eventID;
  int? tokenID;
  String? transaction_external_url;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final firstPossibleDate = DateTime(DateTime.now().year);
  final lastPossibleDate = DateTime(DateTime.now().year + 10);

  TicketCategoryForm({
    @PathParam('ticketCategoryID') this.ticketCategoryID,
    @PathParam('eventID') required this.eventID,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => DeleteTicketCategoryBloc()),
      BlocProvider(create: (context) => CreateTicketCategoryBloc()),
      BlocProvider(create: (context) => UpdateTicketCategoryBloc()),
      if (ticketCategoryID != null)
        BlocProvider(
            create: (context) => ReadTicketCategoryBloc(
                client: getIt<DPGraphQLClient>().graphQLClient,
                ticketCategoryID: ticketCategoryID!)
              ..run()),
    ], child: this);
  }

  @override
  Widget build(BuildContext context) {
    Localization localization = Localization.of(context);
    return WillPopScope(
        onWillPop: () async {
          _formKey.currentState?.save();

          Map<String, dynamic>? a = _formKey.currentState != null
              ? Map.from(_formKey.currentState!.value.cast())
              : null;
          return await DPWillPopAction.onWillPop(
            context,
            showUnsavedChangesAlert:
                !mapEquals(_formKey.currentState?.initialValue, a),
          );
        },
        child: DPScaffold(
            context: context,
            appBar: DPAppBar(
              context: context,
              title: "Ticketing",
              actions: [
                TextButton(
                  onPressed: () => saveItem(context),
                  child: Text(
                    localization.general_save,
                    style: AppTypography.bodyText2.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ),
              ],
            ),
            body: ticketCategoryID != null
                ? buildQueryBloc(context)
                : buildForm(context, null)));
  }

  Widget buildQueryBloc(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<DeleteTicketCategoryBloc,
                  DPMutationState<DeleteTicketCategory$Mutation>>(
              listener: (_, state) {
            if (state.loading ?? false) {
              return DPAlert.showLoadingAlert(
                  context, "Saving...", (p0) => null);
            }
            if (state.failure != null) {
              return FailureDisplay(state.failure!).asAlert(context);
            }
            if (state.success ?? false) {
              if (isWebMode) {
                context.router.popUntil((route) =>
                    route.settings.name == DPSideNavigationWidgetRoute.name);
              } else {
                context.router.popUntil((route) =>
                    route.settings.name == TicketCategoryAdminPageRoute.name);
              }
            }
          }),
          BlocListener<UpdateTicketCategoryBloc,
              DPMutationState<UpdateTicketCategory$Mutation>>(
            listener: (_, state) {
              if (state.loading ?? false) {
                return DPAlert.showLoadingAlert(
                    context, "Saving...", (p0) => null);
              }
              if (state.failure != null) {
                return FailureDisplay(state.failure!).asAlert(context);
              }
              if (state.success ?? false) {
                if (isWebMode) {
                  context.router.popUntil((route) =>
                      route.settings.name == DPSideNavigationWidgetRoute.name);
                } else {
                  context.router.popUntil((route) =>
                      route.settings.name == TicketCategoryAdminPageRoute.name);
                }
              }
            },
          ),
          BlocListener<CreateTicketCategoryBloc,
              DPMutationState<CreateTicketCategory$Mutation>>(
            listener: (_, state) {
              if (state.loading ?? false) {
                return DPAlert.showLoadingAlert(
                    context, "Saving...", (p0) => null);
              }
              if (state.failure != null) {
                return FailureDisplay(state.failure!).asAlert(context);
              }
              if (state.success ?? false) {
                if (isWebMode) {
                  context.router.popUntil((route) =>
                      route.settings.name == DPSideNavigationWidgetRoute.name);
                } else {
                  context.router.popUntil((route) =>
                      route.settings.name == TicketCategoryAdminPageRoute.name);
                  urll.launch(transaction_external_url );
                }
              }
            },
          )
        ],
        child: BlocBuilder<ReadTicketCategoryBloc,
            DPQueryState<ReadTicketCategoryAdmin$Query>>(builder: (_, state) {
          // return buildForm(context, state.data);

          return AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: buildState(context, state),
          );
        }));
  }

  Widget buildState(
      BuildContext context, DPQueryState<ReadTicketCategoryAdmin$Query> state) {
    if (state.loading ?? false) {
      return Center(child: CircularProgressIndicator());
    }

    if (state.failure != null) {
      return FailureDisplay(state.failure!).asText(context);
    }

    if (state.data != null) {
      return buildForm(context, state.data);
    }

    return Container();
  }

  Widget buildForm(BuildContext context, ReadTicketCategoryAdmin$Query? data) {
    Localization localization = Localization.of(context);

    ReadTicketCategoryAdmin$Query$TicketCategories? ticketCategory =
        data != null
            ? (data.ticketCategories.isNotEmpty
                ? data.ticketCategories.first
                : null)
            : null;
    return ListView(
      children: [
        FormBuilder(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          initialValue: ticketCategory != null
              ? {
                  "title": ticketCategory.name,
                  "description": ticketCategory.description,
                  "startSales": ticketCategory.startSales,
                  "endSales": ticketCategory.endSales,
                  "ticketPrice": ticketCategory.ticketPrice,
                  "ticketAmount": ticketCategory.ticketAmount,
                }
              : {},
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create new NFT Ticket",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    DPSecondaryButton(
                      context,
                      buttonWidth: 200,
                      text: "Upload Image",
                      onPressed: () async {
                        final ImagePicker _picker = ImagePicker();
                        // Pick an image
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);

                        File image_file = File(image!.path);

                        NFTPortRepository repository = NFTPortRepository();
                        

                        var result = await repository.createMetadata(image_file,
                            "", "");

                        print(result);

                        var result2 = jsonDecode(result);
                        print(result2);
                        print(result2["metadata_uri"]);

                        // TODO speicher tokenId bei tickettype
                        var rng = Random();
                        var tokenId = rng.nextInt(10000000);
                        tokenID = tokenId;

                        var result3 = await repository.mintTicketType(
                            result2["metadata_uri"],
                            owner_address,
                            contractID,
                            tokenId.toString(),
                            "10");
                        var body = jsonDecode(result3);
                        print(body);

                        transaction_external_url =
                            body["transaction_external_url"];
                      },
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DPTextFormField(
                      context: context,
                      hasBorder: false,
                      name: 'name',
                      labelText: 'name',

                      initialValue: ticketCategory?.name,
                      //onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                        // TODO validierung auch im backend
                        FormBuilderValidators.maxLength(100)
                      ]),
                      minLines: 1,
                      maxLength: 100,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DPTextFormField(
                      context: context,
                      hasBorder: false,

                      name: 'description',
                      labelText: 'description',
                      initialValue: ticketCategory?.description,
                      //onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.minLength(3),
                        FormBuilderValidators.maxLength(4000)
                      ]),
                      minLines: 3,
                      maxLines: 12,
                      maxLength: 4000,
                      autocorrect: false,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Ticket sale",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DPTextFormField(
                      context: context,
                      hasBorder: false,

                      name: 'ticketPrice',
                      labelText: 'ticket price',
                      keyboardType: TextInputType.number,
                      initialValue: ticketCategory?.ticketPrice.toString(),
                      //onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.required(),
                      ]),
                      minLines: 1,
                      maxLength: 100,
                      autocorrect: false,
                    ),
                    DPTextFormField(
                      context: context,
                      hasBorder: false,

                      name: 'ticketAmount',
                      labelText: 'ticket amount',
                      keyboardType: TextInputType.number,
                      initialValue: ticketCategory?.ticketAmount.toString(),
                      //onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.integer(),
                        FormBuilderValidators.required(),
                      ]),
                      minLines: 1,
                      maxLength: 100,
                      autocorrect: false,
                    ),
                    DPDateTimeFormField(
                      context: context,
                      hasBorder: false,

                      name: 'startSales',
                      initialValue: ticketCategory != null
                          ? ticketCategory.startSales
                          : DateTime.now(),

                      format: DPDateConverter.getDateFormat(context, true,
                          numericMonth: true),
                      firstDate: firstPossibleDate,
                      lastDate: lastPossibleDate,
                      labelText: 'start sales',
                      inputType: InputType.both,
                      //initialValue: news?.scheduledTime,
                      // onChanged: _onChanged,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    DPDateTimeFormField(
                      context: context,
                      hasBorder: false,

                      name: 'endSales',
                      initialValue: ticketCategory != null
                          ? ticketCategory.startSales
                          : DateTime.now().add(Duration(days: 1)),

                      format: DPDateConverter.getDateFormat(context, true,
                          numericMonth: true),
                      firstDate: firstPossibleDate,
                      lastDate: lastPossibleDate,
                      labelText: 'end sales',
                      inputType: InputType.both,
                      //initialValue: news?.scheduledTime,
                      // onChanged: _onChanged,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    if (ticketCategoryID != null)
                      DPSecondaryButton(
                        context,
                        buttonWidth: 152,
                        iconData: DashpointIcons.trash_alt,
                        text: localization.general_delete,
                        onPressed: () => showDialog(
                          context: context,
                          builder: (dialogContext) {
                            return AlertDialog(
                              title: Text(
                                  localization.admin_news_delete_alert_title),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => context.router.pop(),
                                  child: Text(
                                    localization.general_cancel,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => context
                                      .read<DeleteTicketCategoryBloc>()
                                      .run(DeleteTicketCategoryArguments(
                                        ticketCategoryID: ticketCategoryID!,
                                      ).toJson()),
                                  child: Text(
                                    localization.general_delete,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> saveItem(BuildContext context) async {
    
    //open ticket in polygon scan
    urll.launch(transaction_external_url}

  Future<void> saveItem2(BuildContext context) async {
    _formKey.currentState?.save();
    if (_formKey.currentState?.validate() ?? false) {
      String? userID = context.read<AuthBloc>().state.mapOrNull(
          authenticated: (a) => a.user.id, anonymous: (a) => a.user.id);
      Map<String, dynamic> values = _formKey.currentState!.value;

      if (ticketCategoryID != null) {
        // TODO add variables and test
        context.read<UpdateTicketCategoryBloc>().run(
            UpdateTicketCategoryArguments(
                    name: values["name"],
                    description: values["description"],
                    endSales: values["endSales"],
                    startSales: values["startSales"],
                    ticketAmount: int.parse(values["ticketAmount"]),
                    ticketCategoryID: ticketCategoryID!,
                    ticketPrice: double.parse(values["ticketPrice"]))
                .toJson());
      } else {
        //create news
        if (userID != null) {
          //TODO test query in apollo
          context.read<CreateTicketCategoryBloc>().run(
              CreateTicketCategoryArguments(
                      description: values['description'],
                      endSales: values['endSales'],
                      eventRolesID: "testRolename",
                      name: values['name'],
                      startSales: values['startSales'],
                      ticketAmount: 2,
                      eventID: eventID,
                      ticketPrice: 1)
                  .toJson());
        }
      }
      // context.router.pop();
    } else {
      print("validation failed");
    }
  }
}
