import 'package:flutter/material.dart';
import 'package:ai_app/models/grains.dart';

class Grain_Tile extends StatelessWidget {
  final Grains grain;
  Grain_Tile({this.grain});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Text(grain.name),
    );
  }
}
