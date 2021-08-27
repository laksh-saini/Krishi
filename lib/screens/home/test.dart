import 'package:ai_app/screens/Products/list_view.dart';

import 'package:flutter/material.dart';

class TestOnly extends StatefulWidget {
  @override
  _TestOnlyState createState() => _TestOnlyState();
}

class _TestOnlyState extends State<TestOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("n"),
      ),
      backgroundColor: Colors.red,
      body: ListScreen(),
    );
  }
}
