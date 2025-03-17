import 'package:flutter/material.dart';

Widget myTabBar(TabController tabController) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(60),
    child: TabBar(
      controller: tabController,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorColor: Colors.black,
      labelStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        color: Colors.blueGrey,
      ),
      tabs: const [
        Tab(text: "Chats"),
        Tab(text: "Groups"),
        Tab(text: "Calls"),
      ],
    ),
  );
}
