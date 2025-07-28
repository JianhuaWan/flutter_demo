import 'dart:math';

import 'package:flutter/material.dart';
import '../util/utils.dart';
import '../widget/photo_widget.dart';
import '../widget/views.dart';

import 'image.dart';

class WrapImgWidget extends StatelessWidget {
  final List<dynamic> imgs;
  final double spacing;
  final double remove;
  final double margin;
  final int count;
  final int w;

  const WrapImgWidget({
    Key key,
    @required this.imgs,
    this.spacing = 8,
    this.count = 3,
    @required this.remove,
    this.margin = 8,
    this.w = 300,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var random = Random().nextInt(9999);
    var wh = size(context).width / count - (remove + (spacing * (count - 1))) / count;
    if (imgs == null || imgs.isEmpty) {
      return SizedBox();
    } else {
      return Container(
        margin: EdgeInsets.symmetric(vertical: margin),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(imgs.length, (i) {
            return GestureDetector(
              onTap: () {
                push(
                  context,
                  PhotoView(images: imgs, index: i),
                  isMove: false,
                );
              },
              child: Hero(
                tag: '${imgs[i]}$random',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: WrapperImage(
                    url: imgs[i],
                    width: wh,
                    height: wh,
                    w: w,
                  ),
                ),
              ),
            );
          }),
        ),
      );
    }
  }
}
