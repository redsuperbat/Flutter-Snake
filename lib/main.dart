import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/home_page_model.dart';
import 'ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: HomePageModel(),
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
