import 'package:flutter/material.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';

class DengjiItemPage extends StatefulWidget {
  final String userLevel;

  const DengjiItemPage({Key key, this.userLevel}) : super(key: key);
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
    // await Request.get(
    //   '/api/User/Level',
    //   data: {"userLevel": widget.userLevel},
    //   catchError: (v) => dengjiItemDm.toError(v),
    //   success: (v) {
    //     dengjiItemDm.object = v['data'];
    //   },
    // );
    dengjiItemDm.setTime();
    setState(() {});
    return dengjiItemDm.flag;
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
                Image.asset('assets/img/dengji_02.png'),
                Image.asset('assets/img/dengji_03.png'),
              ][int.parse(widget.userLevel) - 1],
            ],
          );
          // return MyListView(
          //   isShuaxin: false,
          //   flag: false,
          //   itemCount: obj.length,
          //   divider: Divider(height: 16, color: Colors.transparent),
          //   padding: EdgeInsets.all(16),
          //   physics: BouncingScrollPhysics(),
          //   listViewType: ListViewType.Separated,
          //   item: (i) {
          //     return Container(
          //       padding: EdgeInsets.all(16),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             children: [
          //               Image.asset(
          //                 'assets/img/dengji_1.png',
          //                 width: 25,
          //                 height: 28,
          //               ),
          //               SizedBox(width: 4),
          //               Expanded(
          //                 child: MyText(
          //                   obj[i]['name'],
          //                   isBold: true,
          //                   size: 16,
          //                 ),
          //               ),
          //               MyText(
          //                 obj[i]['remark'],
          //                 size: 12,
          //                 color: Color(0xff757575),
          //               )
          //             ],
          //           ),
          //           Divider(),
          //           MyText(
          //             obj[i]['taskType'],
          //             isBold: true,
          //           ),
          //           SizedBox(height: 10),
          //           MyText(
          //             obj[i]['title'],
          //             size: 13,
          //             color: Color(0xff757575),
          //           ),
          //           SizedBox(height: 10),
          //           Row(
          //             children: [
          //               Expanded(
          //                 child: Stack(
          //                   children: [
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(4),
          //                       child: SizedBox(
          //                         height: 4,
          //                         child: FractionallySizedBox(
          //                           widthFactor: 1,
          //                           heightFactor: 1,
          //                           child: Container(
          //                             color: Theme.of(context).primaryColor.withOpacity(0.1),
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                     ClipRRect(
          //                       borderRadius: BorderRadius.circular(4),
          //                       child: SizedBox(
          //                         height: 4,
          //                         child: FractionallySizedBox(
          //                           widthFactor: obj[i]['finished'].toDouble(),
          //                           heightFactor: 1,
          //                           child: Container(
          //                             color: Theme.of(context).primaryColor,
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(width: 8),
          //               MyText(
          //                 '${obj[i]['finished']}/${obj[i]['total']}',
          //                 size: 12,
          //                 color: Theme.of(context).primaryColor,
          //               ),
          //               SizedBox(width: 76),
          //               WidgetTap(
          //                 isElastic: obj[i]['isDone'],
          //                 onTap: () {},
          //                 child: ClipRRect(
          //                   borderRadius: BorderRadius.circular(4),
          //                   child: Container(
          //                     color: obj[i]['isDone'] ? Theme.of(context).primaryColor : Colors.grey,
          //                     padding: EdgeInsets.only(left: 8, right: 8, top: 3, bottom: 2),
          //                     child: MyText(obj[i]['isDone'] ? '已完成' : '未完成', color: Colors.white, size: 12),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //           SizedBox(height: 22),
          //           WidgetTap(
          //             isElastic: obj[i]['isDone'],
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(4),
          //               child: Container(
          //                 color: obj[i]['isDone'] ? Theme.of(context).primaryColor : Colors.grey,
          //                 width: double.infinity,
          //                 alignment: Alignment.center,
          //                 padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
          //                 child: MyText(obj[i]['isDone'] ? '已达标当前等级' : '未达标当前等级', color: Colors.white, size: 12),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       decoration: BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(10),
          //         boxShadow: [
          //           BoxShadow(
          //             blurRadius: 6,
          //             color: Color(0x80B0C2CC),
          //             offset: Offset(0, 3),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
