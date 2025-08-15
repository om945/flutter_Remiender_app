import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/pages/note_lists_page.dart';
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
    _tabcontroller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  //signOut
  void _signOut(BuildContext context) {
    AuthServices().signOutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvideer>(context).user;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        forceMaterialTransparency: true,
        backgroundColor: bgColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  'Hello... ',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: googleFontNormal,
                  ),
                ),
                Text(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  user.name,
                  style: TextStyle(
                    fontSize: 25.sp,
                    fontFamily: googleFontBold,
                    color: blueColor,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabcontroller,
          tabs: [
            Tab(
              child: Text(
                'Notes',
                style: TextStyle(fontSize: 18.sp, fontFamily: googleFontNormal),
              ),
            ),
            Tab(
              child: Text(
                'To-dos',
                style: TextStyle(fontSize: 18.sp, fontFamily: googleFontNormal),
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
                      fontSize: 15.sp,
                      fontFamily: googleFontNormal,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'Star Message',
                  child: Text(
                    'Star Message',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontFamily: googleFontNormal,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TabBarView(
          controller: _tabcontroller,
          children: [
            ChatPage(),
            Text(
              'Story',
              style: TextStyle(fontSize: 18.sp, fontFamily: googleFontNormal),
            ),
          ],
        ),
      ),
    );
  }
}
