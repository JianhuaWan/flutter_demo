import 'package:flutter/material.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/views.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '消息',
        isNoShowLeft: true,
        color: Colors.white,
      ),
      // body: Center(
      //   child: WidgetTap(
      //     onTap: () {
      //       jumpPage(
      //         Material(
      //           child: TabWidget(
      //             tabList: ['课程简介', '课程目录'],
      //             tabPage: [Container(), Container()],
      //           ),
      //         ),
      //       );
      //     },
      //     child: MyText('开发中...'),
      //   ),
      // ),
    );
  }
}
