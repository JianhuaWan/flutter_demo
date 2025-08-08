import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';

class DengjiItemPage extends StatefulWidget {
  final String? userLevel;

  const DengjiItemPage({Key? key, this.userLevel}) : super(key: key);
  @override
  _DengjiItemPageState createState() => _DengjiItemPageState();
}

class _DengjiItemPageState extends State<DengjiItemPage> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiUserLevel(isRef: true);
  }

  ///获取客户等级
  var dengjiItemDm = DataModel<List>(hasNext: false, object: []);
  Future<int> apiUserLevel({int page = 1, bool isRef = false}) async {
    await Future.delayed(Duration(milliseconds: 500));
    dengjiItemDm.setTime();
    setState(() {});
    return dengjiItemDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldWidget(
      body: AnimatedSwitchBuilder<List>(
        value: dengjiItemDm,
        errorOnTap: () => this.apiUserLevel(isRef: true),
        objectBuilder: (obj) {
          return Column(
            children: [
              SizedBox(height: 4),
              [
                Image.asset('assets/img/dengji_01.png'),
                Image.asset('assets/img/dengji_01.png'),
                Image.asset('assets/img/dengji_01.png'),
              ][int.parse(widget.userLevel!) - 1],
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
