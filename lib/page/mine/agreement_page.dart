import 'package:flutter/material.dart';
import 'package:flutter_app/util/base_http.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/layout/views.dart';

class AgreementPage extends StatefulWidget {
  final String? type;

  const AgreementPage({Key? key, this.type}) : super(key: key);
  @override
  _AgreementPageState createState() => _AgreementPageState();
}

class _AgreementPageState extends State<AgreementPage> {
  @override
  void initState() {
    this.initData();
    super.initState();
  }

  ///初始化函数
  Future initData() async {
    await this.apiProtocolGetProtocolType(isRef: true);
  }

  ///获取协议
  var xieyiDm = DataModel(hasNext: false);
  Future<int> apiProtocolGetProtocolType({int page = 1, bool isRef = false}) async {
    await Request.get(
      '/api/Protocol/GetProtocolType',
      data: {"type": widget.type},
      catchError: (v) => xieyiDm.toError(v),
      success: (v) {
        xieyiDm.object = v['data'];
        xieyiDm.setTime();
      },
    );
    setState(() {});
    return xieyiDm.flag!;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: {
          '11': '隐私政策',
          '12': '用户协议',
        }[widget.type]!,
        color: Colors.white,
      ),
      bgColor: Colors.white,
      body: AnimatedSwitchBuilder(
        value: xieyiDm,
        errorOnTap: () => this.apiProtocolGetProtocolType(isRef: true),
        isAnimatedSize: true,
        objectBuilder: (obj) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            // child: Html(
            //   data: obj,
            // ),
          );
        },
      ),
    );
  }
}
