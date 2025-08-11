import 'package:flutter/material.dart';
import 'package:flutter_app/provider/app_provider.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/res/app_string.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:provider/provider.dart';

class CoreTabWidget extends StatefulWidget {
  final Function(int)? callback;

  const CoreTabWidget({Key? key, this.callback}) : super(key: key);

  @override
  _CoreTabWidgetState createState() => _CoreTabWidgetState();
}

class _CoreTabWidgetState extends State<CoreTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            color: Colors.black12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              children: <Widget>[
                buildBtb(AppString.home, 0),
                buildBtb(AppString.information, 1),
                buildBtb(AppString.recommend, 2),
                buildBtb(AppString.me, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBtb(text, _index) {
    return Expanded(
      child: WidgetTap(
        isElastic: true,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          widget.callback!(_index);
          app.changeBtmIndex(_index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          child: Selector<AppProvider, int>(
            selector: (_, k) => k.btmIndex,
            builder: (_, v, view) {
              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset(
                        [
                          [
                            'assets/img/home_inactive.png',
                            'assets/img/home_active.png',
                          ][v == 0 ? 0 : 1],
                          [
                            'assets/img/home_inactive.png',
                            'assets/img/home_active.png',
                          ][v == 1 ? 0 : 1],
                          [
                            'assets/img/home_inactive.png',
                            'assets/img/home_active.png',
                          ][v == 2 ? 0 : 1],
                          [
                            'assets/img/home_inactive.png',
                            'assets/img/home_active.png',
                          ][v == 3 ? 0 : 1],
                        ][_index],
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  MyText(
                    text,
                    color: _index == v
                        ? Theme.of(context).primaryColor
                        : Colors.black,
                    size: 10,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
