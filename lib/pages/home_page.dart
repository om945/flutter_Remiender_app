import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/pages/favorite_page.dart';
import 'package:remiender_app/pages/note_lists.dart';
import 'package:remiender_app/pages/todo_list.dart';
import 'package:remiender_app/services/auth_services.dart';
import 'package:remiender_app/theme/theme.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabcontroller;

  bool _isSearching = false;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _tabcontroller.dispose();
    super.dispose();
  }

  //signOut
  void _signOut(BuildContext context) {
    AuthServices().signOutUser(context);
  }

  void showPopDialog() {
    showDialog(
      context: context,
      builder: (BuildContext contxt) {
        return AlertDialog(
          title: Text(
            'Sign out',
            style: TextStyle(fontFamily: googleFontBold, color: whiteColor),
          ),
          content: Text(
            'Are you sure! you want to sign out',
            style: TextStyle(
              fontFamily: googleFontNormal,
              color: faintwhiteColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: blueColor,
                  fontFamily: googleFontNormal,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _signOut(context),
              child: Text(
                'Delete',
                style: TextStyle(
                  color: blueColor,
                  fontFamily: googleFontNormal,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        forceMaterialTransparency: true,
        backgroundColor: bgColor,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Flexible(
            child: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: TextStyle(color: whiteColor, fontSize: 18.sp),
                    decoration: InputDecoration(
                      hintText: 'Search notes/todos...',
                      hintStyle: TextStyle(
                        color: faintwhiteColor,
                        fontSize: 18.sp,
                      ),
                      border: InputBorder.none,
                    ),
                    onChanged: (query) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(milliseconds: 500), () {
                        setState(() {
                          _searchQuery = query;
                        });
                      });
                    },
                  )
                : Column(
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
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _searchQuery = '';
                  // Optionally, notify NotesList to clear search results
                }
              });
            },
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
          ),
          IconButton(onPressed: showPopDialog, icon: const Icon(Icons.logout)),
          PopupMenuButton<String>(
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
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const FavoritePage(),
                        transitionDuration: Duration(microseconds: 200),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1, 0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              
                              var tween = Tween(
                                begin: begin,
                                end: end,
                              ).chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                      ),
                    );
                  },
                  value: 'Star Message',
                  child: Text(
                    'Favorite Notes',
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
            NotesList(searchQuery: _searchQuery),
            TodoList(searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}
