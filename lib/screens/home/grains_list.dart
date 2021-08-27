import 'package:ai_app/screens/home/grain_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:ai_app/models/grains.dart';

class GrainList extends StatefulWidget {
  @override
  _GrainListState createState() => _GrainListState();
}

class _GrainListState extends State<GrainList> {
  @override
  Widget build(BuildContext context) {
    final grains = Provider.of<List<Grains>>(context);

    return ListView.builder(
      itemCount: grains.length,
      itemBuilder: (context, index) {
        return Grain_Tile(grain: grains[index]);
      },
    );
  }
}
