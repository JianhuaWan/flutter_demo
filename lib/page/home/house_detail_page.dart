import 'package:flutter/material.dart';
import 'package:flutter_app/widget/no_sliding_widget.dart';
import 'package:flutter_app/widget/tab_link_widget.dart';
import 'package:flutter_app/widget/animation_widget.dart';
import 'package:flutter_app/widget/base_widgets.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';

class HouseDetailPage extends StatefulWidget {
  final Map? data;

  const HouseDetailPage({Key? key, this.data}) : super(key: key);
  @override
  _HouseDetailPageState createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> with SlidingReturn, TickerProviderStateMixin {
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(
        context,
        title: '楼盘全部信息',
        color: Colors.white,
      ),
      body: TabLinkWidget(
        isScrollable: false,
        // isBottom: true,
        headers: ['基本信息', '销售信息', '预售许可'],
        listBar: [
          Container(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: MyListView(
              isShuaxin: false,
              item: (i) {
                return AnimationWidget(
                  time: 1000 + 50 * i,
                  curve: ElasticOutCurve(0.5),
                  child: ItemEditWidget(
                    text: [
                      widget.data!['buildingName'],
                      widget.data!['buildingFeature'],
                      doubleToYuan(widget.data!['consultAvgPrice']),
                      doubleToWan(widget.data!['consultTotalPrice']),
                      widget.data!['propertyType'],
                      '${widget.data!['buildType']}',
                      '${widget.data!['propertyRight']}年',
                      widget.data!['developer'],
                      '${widget.data!['city']}-${widget.data!['area']}',
                      widget.data!['buildAddress'],
                    ][i],
                    title: [
                      '楼盘别名',
                      '楼盘特色',
                      '参考均价',
                      '参考总价',
                      '物业类型',
                      '建筑类型',
                      '产权年限',
                      '开发商',
                      '所在地区',
                      '楼盘地址',
                    ][i],
                    titleColor: Color(0xff666666),
                    isShowDivider: false,
                  ),
                );
              },
              itemCount: 10,
              listViewType: ListViewType.Separated,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: MyListView(
              isShuaxin: false,
              item: (i) {
                return ItemEditWidget(
                  text: [
                    '${widget.data!['floorSapce']}㎡',
                    '${widget.data!['buildingArea']}㎡',
                    '${widget.data!['reservedLand']}',
                    '${widget.data!['packingUnit']}',
                    '${widget.data!['packtingRatio']}',
                    '${widget.data!['planBuildings']}',
                    '${widget.data!['planHubs']}',
                    '${widget.data!['propertyName']}',
                    '${widget.data!['propertyPrice']}元',
                    '${widget.data!['powerWay']}',
                    '${widget.data!['heatingWay']}',
                    '${widget.data!['wateringWay']}',
                  ][i],
                  title: [
                    '占地面积',
                    '建筑面积',
                    '容积率',
                    '规划车位',
                    '车位配比',
                    '规划楼栋',
                    '规划户数',
                    '物业公司',
                    '物业费用',
                    '供电',
                    '供暖方式',
                    '供水',
                  ][i],
                  titleColor: Color(0xff666666),
                  isShowDivider: false,
                );
              },
              itemCount: 12,
              listViewType: ListViewType.Separated,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: MyListView(
              isShuaxin: false,
              item: (i) {
                return ItemEditWidget(
                  text: [
                    widget.data!['presellingCertificate'],
                    widget.data!['certificateDate'],
                    // widget.data['bindBuilding'],
                  ][i],
                  title: [
                    '预售证',
                    '发证日期',
                    // '预售楼栋',
                  ][i],
                  titleColor: Color(0xff666666),
                  isShowDivider: false,
                );
              },
              itemCount: 2,
              listViewType: ListViewType.Separated,
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
        ],
      ),
    );
  }

  String doubleToWan(value) {
    flog(value);
    var v = (value == null || value == '') ? 0 : value;
    return v.toString() + '(万元)';
  }

  String doubleToYuan(value) {
    flog(value);
    var v = (value == null || value == '') ? 0 : value;
    return v.toString() + '(元)';
  }
}
