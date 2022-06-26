import 'package:dashpoint/core/design/icons/dashpoint_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Cards {
  late List<Color> color;
  late String name;
  late String address;
  late IconData icon;
  late String money;
  late IconData bank;

  Cards(
      {required this.name,
      required this.color,
      required this.money,
      required this.icon,
      required this.bank});
}

List<Cards> cardinfo = [
  Cards(
    name: "Polygon",
    color: const [Color(0xFFE96443), Color(0xFF904E95)],
    money: "5634.0",
    icon: FontAwesomeIcons.ethereum,
    bank: DashpointIcons.walletconnect_logo,
  ),
  Cards(
      name: "Ethereum",
      color: const [Color(0xFF00D2FF), Color(0xFF928DAB)],
      money: "2644.0",
      icon: FontAwesomeIcons.ethereum,
      bank: DashpointIcons.walletconnect_logo),
  Cards(
      name: "Amirziy",
      color: const [Color(0xFFFFC371), Color(0xFFFF5F6D)],
      money: "7684.0",
      icon: FontAwesomeIcons.ethereum,
      bank: DashpointIcons.walletconnect_logo),
];
