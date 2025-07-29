import 'package:flutter_app_series_api/custom_drawer.dart';
import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final Widget child;

  const BaseScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [Text('I Love Series 🎬')],
          ),
        ),
        drawer: CustomDrawer(),
        body: child,
      );
  }
}
