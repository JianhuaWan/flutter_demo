import 'package:flutter/material.dart';
import 'package:flutter_app/provider/app_provider.dart';
import 'package:flutter_app/provider/chat_provider.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

class BnbWidget extends StatefulWidget {
  final Function(int) callback;

  const BnbWidget({Key key, this.callback}) : super(key: key);

  @override
  _BnbWidgetState createState() => _BnbWidgetState();
}

class _BnbWidgetState extends State<BnbWidget> {
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
                buildBtb('tab0', 0),
                buildBtb('tab1', 1),
                buildBtb('tab2', 2),
                buildBtb('tab3', 3),
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
          widget.callback(_index);
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
                            'assets/img/home0.png',
                            'assets/img/home1.png',
                          ][v == 0 ? 0 : 1],
                          [
                            'assets/img/home0.png',
                            'assets/img/home1.png',
                          ][v == 1 ? 0 : 1],
                          [
                            'assets/img/home0.png',
                            'assets/img/home1.png',
                          ][v == 2 ? 0 : 1],
                          [
                            'assets/img/home0.png',
                            'assets/img/home1.png',
                          ][v == 3 ? 0 : 1],
                        ][_index],
                        width: 24,
                        height: 24,
                      ),
                      if (_index == 3)
                        Positioned(
                          right: -6,
                          top: -2,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(56),
                                child: Selector<ChatProvider, int>(
                                  selector: (_, k) => k.totalUnreadCount,
                                  builder: (_, v, view) {
                                    return AnimatedOpacity(
                                      duration: Duration(milliseconds: 250),
                                      opacity: v == 0 ? 0 : 1,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        constraints: BoxConstraints(
                                            minWidth: 12, minHeight: 12),
                                        alignment: Alignment.center,
                                        color: Color(0xffe95e58),
                                        child: MyText(v,
                                            color: Colors.white, size: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
