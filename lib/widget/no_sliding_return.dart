import 'package:flutter/material.dart';

mixin NoSlidingReturn<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    // isSliding = true;
    super.initState();
  }

  @override
  void dispose() {
    // isSliding = false;
    super.dispose();
  }
}

mixin SlidingReturn<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    // isSliding = false;
    super.initState();
  }

  @override
  void dispose() {
    // isSliding = true;
    super.dispose();
  }
}
