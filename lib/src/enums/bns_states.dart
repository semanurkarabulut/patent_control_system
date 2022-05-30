import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum MenuState { search, account }

class TabItemData {
  final String label;
  final IconData? icon;
  final IconData? faIcon;

  TabItemData({required this.label, required this.icon, required this.faIcon});

  static Map<MenuState, TabItemData> allTabs = {
    MenuState.search:
        TabItemData(label: "Arama", icon: Icons.search, faIcon: null),
    MenuState.account:
        TabItemData(label: "Hesap", icon: null, faIcon: Icons.person),
  };
}
