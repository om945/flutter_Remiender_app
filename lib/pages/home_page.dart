import 'package:flutter/material.dart';
import 'package:remiender_app/pages/chat_page.dart';
// import 'package:provider/provider.dart';
// import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabcontroller;
  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  //signOut
  void _signOut(BuildContext context) {
    AuthServices().signOutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvideer>(context).user;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: bgColor,
        title: const Text('Chat'),
        bottom: TabBar(
          controller: _tabcontroller,
          tabs: [
            Tab(
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 18, fontFamily: googleFontNormal),
              ),
            ),
            Tab(
              child: Text(
                'Story',
                style: TextStyle(fontSize: 18, fontFamily: googleFontNormal),
              ),
            ),
            Tab(
              child: Text(
                'Call',
                style: TextStyle(fontSize: 18, fontFamily: googleFontNormal),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              // ignore: avoid_print
              print(value);
            },
            color: bgColor,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'Setting',
                  child: Text(
                    'Setting',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: googleFontNormal,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'Star Message',
                  child: Text(
                    'Star Message',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: googleFontNormal,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'New Group',
                  child: Text(
                    'New Group',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: googleFontNormal,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabcontroller,
        children: [
          ChatPage(),
          Text(
            'Story',
            style: TextStyle(fontSize: 18, fontFamily: googleFontNormal),
          ),
          Text(
            'call',
            style: TextStyle(fontSize: 18, fontFamily: googleFontNormal),
          ),
        ],
      ),
    );
  }
}
