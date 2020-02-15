import 'package:flutter/material.dart';
import 'package:scan_vision_app/core/common/route_generator.dart';

import 'core/common/routes.dart';

void main() => runApp(VisionApp());

class VisionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scan Vision App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
