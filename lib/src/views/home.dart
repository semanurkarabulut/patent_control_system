import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:patent_control_system/src/components/custom_bnb.dart';
import 'package:patent_control_system/src/enums/bns_states.dart';
import 'package:patent_control_system/src/services/database.dart';
import 'package:patent_control_system/src/views/account_page.dart';
import 'package:patent_control_system/src/views/search_page.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuState currentState = MenuState.search;
  QuerySnapshot? sugSnapshot;

  Map<MenuState, Widget> allPages() {
    return {MenuState.search: SearchPage(), MenuState.account: AccountPage()};
  }

  Map<MenuState, GlobalKey<NavigatorState>> navigatorKeys = {
    MenuState.search: GlobalKey<NavigatorState>(),
    MenuState.account: GlobalKey<NavigatorState>()
  };

  // Future<void> loadUserInfo() async {
  //   Constants.myFullName = await HelperFunctions.getUserFullName();
  // }

  @override
  Widget build(BuildContext context) {
    DatabaseMethods db = DatabaseMethods();
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[currentState]!.currentState!.maybePop(),
      child: FutureBuilder(
          future: db.getUserInfo(FirebaseAuth.instance.currentUser!.email!),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return CustomBottomNavbar(
                navigatorKeys: navigatorKeys,
                createPage: allPages(),
                selectedMenu: currentState,
                onSelectedTab: (selectedTab) {
                  if (selectedTab == currentState) {
                    navigatorKeys[selectedTab]!
                        .currentState!
                        .popUntil((route) => route.isFirst);
                  } else {
                    setState(() {
                      currentState = selectedTab;
                    });
                  }
                  ;
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Container(
                  child: SafeArea(
                    child: Scaffold(
                      backgroundColor: HexColor("3F72AF"),
                      body: Center(
                          child: JumpingDotsProgressIndicator(
                        color: Colors.white,
                        fontSize: 80,
                      )),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
