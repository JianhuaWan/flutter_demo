import 'package:flutter/material.dart';
import 'package:flutter_app/util/color_config.dart';
import 'package:flutter_app/util/screen_unit.dart';

import '../res/app_image.dart';
import '../res/app_string.dart';
import '../util/common_views.dart';

class NotNetworkHint extends StatelessWidget {
  const NotNetworkHint({super.key});

  Widget get iconWidget {
    String value = AppImage.icWarnHint; 
    Widget child;
    child = Image.asset(value, width: 22.w, fit: BoxFit.fitWidth,);
    child = Padding(padding: EdgeInsets.only(left: 6.w, right: 6.w),
      child: child,
    );
    return child;
  }

  Widget get infoWidget {
    Widget child;
    child = Text.rich(TextSpan(
      children: [
        WidgetSpan(child: iconWidget),
        TextSpan(text: AppString.networkErrHint,
          style: mediumStyle(textSize: 14.sp, textColor: CommonColor.delColor)
        )
      ]
    ));
    return child;
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    child = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w, bottom: 8.w),
      color: CommonColor.warnBgColor,
      child: infoWidget,
    );
    return child;
  }
}