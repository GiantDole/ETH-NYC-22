import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:dashpoint/core/bloc/dp_query_bloc/dp_query_state.dart';
import 'package:dashpoint/core/design/icons/dashpoint_icons.dart';
import 'package:dashpoint/feature_components/user/user_bloc/user_bloc.dart';
import 'package:dashpoint/injection.dart';
import 'package:dashpoint/pages/user_menu/wallet/wallet_design/datecard_model.dart';
import 'package:dashpoint/pages/user_menu/wallet/wallet_design/fadeanimation.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart' as http;

import '../../../../core/wallet_connect/wallet_connect_bloc/wallet_connect_bloc.dart';
import '../../../../graphql/requests.graphql_api.graphql.dart';

class Swipercard extends StatelessWidget {
  const Swipercard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;

    return BlocBuilder<UserBloc, DPQueryState<User$Query$Users?>>(
      bloc: getIt<UserBloc>(),
      builder: (context, user) {
        return BlocBuilder<WalletConnectBloc, WalletConnectState>(
          bloc: getIt<WalletConnectBloc>(),
          builder: (context, walletState) {
            var cards = [
              if (walletState.connected) ...[
                AccountCard(
                  he: he,
                  we: we,
                  name: walletState.chainName,
                  walletAddress:
                      walletState.selectedWalletAddress ?? "No wallet Selected",
                  balance: "5634.0",
                  functionality: DashpointIcons.walletconnect_logo,
                  currency: DashpointIcons.polygon_matic_logo,
                  icon: DashpointIcons.polygon_matic_logo,
                  colors: const [Color(0xFFE96443), Color(0xFF904E95)],
                )
              ],
              // AccountCard(
              //   he: he,
              //   we: we,
              //   name: walletState.chainName,
              //   walletAddress:
              //       walletState.selectedWalletAddress ?? "No wallet Selected",
              //   balance: "5634.0",
              //   functionality: DashpointIcons.walletconnect_logo,
              //   currency: FontAwesomeIcons.dollarSign,
              //   icon: FontAwesomeIcons.ethereum,
              //   colors: const [Color(0xFFE96443), Color(0xFF904E95)],
              // ),
              AddWalletCard(
                he: he,
                we: we,
                name: walletState.chainName,
                balance: "5634.0",
                functionality: DashpointIcons.walletconnect_logo,
                currency: FontAwesomeIcons.dollarSign,
                icon: FontAwesomeIcons.ethereum,
                colors: const [Color(0xFF00D2FF), Color(0xFF928DAB)],
              )
            ];

            return FadeAnimation(
              delay: 1.5,
              child: Swiper(
                itemCount: cards.length,
                layout: SwiperLayout.TINDER,
                itemWidth: 400,
                itemHeight: 340,
                itemBuilder: (c, i) {
                  return cards[i];
                },
              ),
            );
          },
        );
      },
    );
  }
}

class AddWalletCard extends StatelessWidget {
  final double he;
  final double we;
  final List<Color> colors;
  final String name;
  final String balance;
  final IconData functionality;
  final IconData icon;
  final IconData currency;

  const AddWalletCard(
      {Key? key,
      required this.he,
      required this.we,
      required this.colors,
      required this.name,
      required this.balance,
      required this.functionality,
      required this.icon,
      required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          getIt<WalletConnectBloc>().add(WalletConnectEvent.createSession()),
      child: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            SizedBox(height: he * 0.015),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Center(
                      child: Column(
                        children: [
                          FaIcon(
                            DashpointIcons.walletconnect_logo,
                            size: we * 0.2,
                          ),
                          SizedBox(height: he * 0.03),
                          AutoSizeText(
                            "Connect Wallet with WalletConnect",
                          ),
                        ],
                      ),
                    )),
              ),
            )
          ])
        ],
      ),
    );
  }
}

class AccountCard extends StatelessWidget {
  final double he;
  final double we;
  final List<Color> colors;
  final String name;
  final String balance;
  final IconData functionality;
  final IconData icon;
  final IconData currency;
  final String walletAddress;

  const AccountCard(
      {Key? key,
      required this.he,
      required this.we,
      required this.colors,
      required this.name,
      required this.balance,
      required this.functionality,
      required this.icon,
      required this.currency,
      required this.walletAddress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          launchUrlString("https://polygonscan.com/address/" + walletAddress),
      child: Stack(
        children: <Widget>[
          Column(children: <Widget>[
            SizedBox(height: he * 0.015),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      )
                    ],
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Badge(
                            badgeColor: Colors.green,
                            position: BadgePosition.topEnd(top: 16, end: -20),
                            child: Text(name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                )),
                          ),
                          SizedBox(
                            width: we * 0.5,
                          ),
                          FaIcon(icon, size: we * 0.07, color: Colors.white),
                        ],
                      ),
                      SizedBox(
                        height: he * 0.03,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(walletAddress.substring(0, 4),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: we * 0.04),
                            const Text("••••",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: we * 0.04),
                            const Text("••••",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: we * 0.04),
                            Text(
                                walletAddress.substring(
                                    walletAddress.length - 4,
                                    walletAddress.length),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: he * 0.05,
                      ),
                      Container(
                          margin: const EdgeInsets.only(right: 200),
                          child: const Text(
                            "Available Balance",
                            style: TextStyle(color: Colors.white),
                          )),
                      SizedBox(height: he * 0.01),
                      Row(children: <Widget>[
                        FaIcon(currency, size: we * 0.06, color: Colors.white),
                        FutureBuilder<String>(
                            future: http
                                .get(
                                    Uri.parse(
                                        'https://api-eu1.tatum.io/v3/polygon/account/balance/${walletAddress}'),
                                    headers: {
                                      'x-api-key':
                                          '719fc54b-c60d-4897-bf42-9452ba0a0365'
                                    })
                                .then((value) => jsonDecode(value.body))
                                .then((value) => double.parse(value["balance"])
                                    .toStringAsPrecision(3)),
                            builder: (context, snapshot) {
                              return Text(
                                " " + (snapshot.data ?? "••••••"),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                        SizedBox(width: we * 0.45),
                        FaIcon(functionality,
                            size: we * 0.09, color: Colors.white),
                      ]),
                    ],
                  ),
                ),
              ),
            )
          ])
        ],
      ),
    );
  }
}
