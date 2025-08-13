import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:remiender_app/Provider/user_provider.dart';
import 'package:remiender_app/theme/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<UserProvideer>(context).user;
    return Scaffold(
      appBar: AppBar(forceMaterialTransparency: true, backgroundColor: bgColor),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
