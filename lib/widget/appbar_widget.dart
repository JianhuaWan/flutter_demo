import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/page/home/city_selecto.dart';
import 'package:flutter_app/page/home/sousuo_page.dart';
import 'package:flutter_app/provider/app_provider.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/route.dart';
import 'package:paixs_utils/widget/views.dart';
import 'package:paixs_utils/widget/widget_tap.dart';
import 'package:provider/provider.dart';

class AppbarWidget extends StatelessWidget {
  final Function callback;
  const AppbarWidget({
    Key key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 10,
        top: padd(context).top + 10,
      ),
      // padding: EdgeInsets.symmetric(horizontal: 17, vertical: 6),
      color: Colors.white,
      child: WidgetTap(
        onTap: () {
          jumpPage(SousuoPage());
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(56),
            color: Color(0xffF5F5F5),
          ),
          child: Row(
            children: [
              WidgetTap(
                isElastic: true,
                onTap: () {
                  jumpPage(PhoneCountryCodePage(), callback: (v) => callback(v));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Image.asset(
                          'assets/img/home_dingwei.png',
                          width: 13,
                          height: 13,
                        ),
                      ),
                      SizedBox(width: 9),
                      Selector<AppProvider, String>(
                        selector: (_, k) => k.city,
                        builder: (_, v, view) {
                          return MyText(v ?? '请稍后', size: 13);
                          // if (v == null) {
                          //   return MyText(v, size: 13);
                          // } else {
                          //   return MyText(v, size: 13);
                          // }
                        },
                      ),
                      SizedBox(width: 16),
                      Container(
                        height: 18,
                        width: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              Image.asset(
                'assets/img/home_sousuo.png',
                width: 13,
                height: 13,
              ),
              SizedBox(width: 11),
              Expanded(
                child: MyText(
                  '请输入关键词搜索',
                  size: 13,
                  color: Color(0xffB7B7B7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
