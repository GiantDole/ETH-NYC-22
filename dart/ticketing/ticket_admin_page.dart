import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:dashpoint/core/nftport/repository.dart';
import 'package:dashpoint/core_components/dp_alert/dp_alert.dart';
import 'package:dashpoint/core_components/dp_feature_publish_button/dp_feature_publish_button.dart';
import 'package:dashpoint/core_components/dp_primary_button/dp_primary_button.dart';
import 'package:dashpoint/core_components/dp_secondary_button/dp_secondary_button.dart';
import 'package:dashpoint/generated/l10n.dart';
import 'package:dashpoint/graphql/graphql_client.dart';
import 'package:dashpoint/graphql/graphql_extension.dart';
import 'package:dashpoint/graphql/requests.graphql_api.dart';
import 'package:dashpoint/injection.dart';
import 'package:dashpoint/core/bloc/dp_mutation_bloc/dp_mutation_state.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_state.dart';
import 'package:dashpoint/core_components/dp_app_bar/dp_app_bar.dart';
import 'package:dashpoint/core_components/dp_loading_indicator/dp_loading_indicator.dart';
import 'package:dashpoint/core_components/dp_scaffold/dp_scaffold.dart';
import 'package:dashpoint/core_components/failure/failure_display.dart';
import 'package:dashpoint/pages/event_main/admin/ticketing/main/blocs/create_ticketing_bloc.dart';
import 'package:dashpoint/pages/event_main/admin/ticketing/main/blocs/read_ticketing_bloc.dart';
import 'package:dashpoint/pages/event_main/admin/ticketing/ticket_category_form/blocs/delete_ticket_category_bloc.dart';
import 'package:dashpoint/core/design/app_color.dart';
import 'package:dashpoint/routes/router.gr.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class TicketAdminPage extends StatelessWidget implements AutoRouteWrapper {
  final String eventID;
  final bool hasTicketingRights; //REMOVE
  const TicketAdminPage(
      {Key? key, required this.eventID, required this.hasTicketingRights})
      : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => CreateTicketingBloc()),
      BlocProvider(
          create: (context) => ReadTicketingBloc(
              client: getIt<DPGraphQLClient>().graphQLClient, eventID: eventID)
            ..run()),
    ], child: this);
  }

  @override
  Widget build(BuildContext context) {
    Localization localization = Localization.of(context);

    return MultiBlocListener(listeners: [
      BlocListener<CreateTicketingBloc,
          DPMutationState<CreateTicketing$Mutation>>(
        listener: (_, state) {
          if (state.loading ?? false) {
            return DPAlert.showLoadingAlert(context, "Saving...", (p0) => null);
          }
          if (state.failure != null) {
            return FailureDisplay(state.failure!).asAlert(context);
          }
          if (state.success ?? false) {
            //TODO update query bloc
            context.read<ReadTicketingBloc>().run();
            context.router.pop();
          }
        },
      )
    ], child: buildQueryBloc(context));
  }

  Widget buildQueryBloc(BuildContext context) {
    return BlocBuilder<ReadTicketingBloc, DPQueryState<Ticketings$Query>>(
        builder: (context, state) => DPScaffold(
              appBar: DPAppBar(
                context: context,
                title: "Ticketing",
                actions: [DPFeaturePublishButton.ticketing(eventID)],
              ),
              body: state.data == null
                  ? DPLoadingIndicator()
                  : state.data!.ticketings.isNotEmpty
                      ? buildBody(context, state.data!)
                      : empty(context),
              context: context,
            ));
  }

  Widget buildBody(BuildContext context, Ticketings$Query data) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            color: Theme.of(context).dialogBackgroundColor,
            child: Container(
              height: 220,
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tickets sold: 7/100",
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontSize: 23),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Total of all ticket categories sold.",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  DPPrimaryButton(
                    text: "Edit Tickets",
                    onPressed: () => context.router.push(
                      TicketCategoryAdminPageRoute(
                        eventID: eventID,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Total amount of categories: 4",
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // DPSecondaryButton(context, text: "Create event NFT",
          //     onPressed: () async {
          //   NFTPortRepository repository = NFTPortRepository();
          //   const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

          //   // TODO comment out for prod
          //   // var result = await repository.mintEventNFT1155(
          //   //     "MarcsTestEvent", "eventNFT", owner_address, "polygon");
          //   // print(result);
          // }),
          // SizedBox(
          //   height: 10,
          // ),
          // DPSecondaryButton(context, text: "Get contract address",
          //     onPressed: () async {
          //   NFTPortRepository repository = NFTPortRepository();
          //   const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

          //   var result = await repository.getContractAddress(
          //       "0x86445e48e5ae23f6877d3227fda66c20ebaf19c1aa27531b00a39bf89c937622",
          //       "polygon");
          //   var body = jsonDecode(result.body);
          //   print(body["contract_address"]);
          // }),

          // SizedBox(
          //   height: 10,
          // ),
          // DPSecondaryButton(context, text: "Upload image", onPressed: () async {
          //   NFTPortRepository repository = NFTPortRepository();
          //   const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

          //   final ImagePicker _picker = ImagePicker();
          //   // Pick an image
          //   final XFile? image =
          //       await _picker.pickImage(source: ImageSource.gallery);
          //   File image_file = File(image!.path);

          //   // var file = await File(
          //   //     "/Users/marc/local-dev/dashpoint/dashpoint-app/assets/images/default/blank-profile-picture.png");
          //   // // TODO comment out for prod

          //   var result = await repository.createMetadata(
          //       image_file, "ticketcategory", "first category image");
          //   print(result);
          //   print("asd");
          // }),

          // SizedBox(
          //   height: 10,
          // ),
          // DPSecondaryButton(context, text: "MINT tickettype",
          //     onPressed: () async {
          //   NFTPortRepository repository = NFTPortRepository();
          //   const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

          //   const metaDataUrl =
          //       "ipfs://bafkreibuyytlcofj4u2h253nvov5qwy7vab2teabldpnfyipblo5rvmq7i";

          //   const contractID = "0xa996b28d76ED8D8E4da49852B4A22C881A50b8c5";

          //   // TODO speicher tokenId bei tickettype
          //   var rng = Random();
          //   var tokenId = rng.nextInt(10000000);
          //   var result = await repository.mintTicketType(metaDataUrl,
          //       owner_address, contractID, tokenId.toString(), "10");
          //   var body = jsonDecode(result);
          //   print(body);
          // }),
          // SizedBox(
          //   height: 10,
          // ),
          // DPSecondaryButton(context, text: "Upload and Mint Image",
          //     onPressed: () async {
          //   NFTPortRepository repository = NFTPortRepository();
          //   const contractID = "0xa996b28d76ED8D8E4da49852B4A22C881A50b8c5";
          //   const owner_address = "0xef74F6B2d2D38bFBBE70590E75f3301Eba8c775b";

          //   final ImagePicker _picker = ImagePicker();
          //   // Pick an image
          //   final XFile? image =
          //       await _picker.pickImage(source: ImageSource.gallery);
          //   File image_file = File(image!.path);

          //   // var file = await File(
          //   //     "/Users/marc/local-dev/dashpoint/dashpoint-app/assets/images/default/blank-profile-picture.png");
          //   // // TODO comment out for prod

          //   String result = await repository.createMetadata(
          //       image_file, "ticketcategory", "first category image");
          //   print(result);
          //   var result2 = jsonDecode(result);
          //   print("finished upload image to IPFS");

          //   var rng = Random();
          //   var tokenId = rng.nextInt(10000000);
          //   var result3 = await repository.mintTicketType(
          //       result2["metadata_uri"],
          //       owner_address,
          //       contractID,
          //       tokenId.toString(),
          //       "10");
          //   var body = jsonDecode(result3);
          //   print(body);
          // }),

          SizedBox(
            height: 30,
          ),
          //       Container(
          //         padding: EdgeInsets.all(16.0),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               "Payment method",
          //               style: Theme.of(context)
          //                   .textTheme
          //                   .headline2!
          //                   .copyWith(fontSize: 23),
          //               textAlign: TextAlign.left,
          //             ),
          //             Text(
          //               "Chose a payment method",
          //               style: Theme.of(context).textTheme.bodyText1,
          //               textAlign: TextAlign.left,
          //             ),
          //             SizedBox(
          //               height: 10,
          //             ),
          //             Container(
          //               width: double.infinity,
          //               child: DPSecondaryButton(
          //                 context,
          //                 text: "Add payment",
          //                 onPressed: () => context.router.push(
          //                   TicketCategoryAdminPageRoute(
          //                     eventID: eventID,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       )
        ],
      ),
    );
  }

  Widget proBadge(BuildContext context) {
    return Chip(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColor.primary, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      label: Text(
        "PRO",
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  void createTicketing(BuildContext context) {
    context
        .read<CreateTicketingBloc>()
        .run(CreateTicketingArguments(eventId: eventID).toJson());
  }

  Widget empty(BuildContext context) {
    Localization localization = Localization.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: Theme.of(context).dialogBackgroundColor,
        child: Container(
          height: 470,
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Ticketing",
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(fontSize: 23),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  proBadge(context)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Integrated Ticketsystem",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "10% service fee for your visitors;",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "max. 10€ per ticket",
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              DPPrimaryButton(
                  text: "Enable Ticketing",
                  onPressed: () => createTicketing(context)),
              SizedBox(
                height: 10,
              ),
              Divider(),
              ...ticketFeatureList(context)
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> ticketFeatureList(BuildContext context) {
    return [
      Text(
        "Features",
        style: Theme.of(context).textTheme.headline5,
        textAlign: TextAlign.left,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        "- Unlimited visitors",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
      Text(
        "- Highlighted in event search",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
      Text(
        "- Automated refunds",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
      Text(
        "- Personalised tickets",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
      Text(
        "- Ticket revenue dashboard",
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.left,
      ),
    ];
  }
}
