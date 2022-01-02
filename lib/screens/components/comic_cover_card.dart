
import 'package:flutter/material.dart';
import 'package:jasmine/basic/entities.dart';

import 'images.dart';

class ComicCoverCard extends StatelessWidget{
  final ComicBasic data;

  const ComicCoverCard(this.data,{Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              JM3x4Cover(
                comicId: data.id,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ],
          );
        },
      ),
    );
  }

}