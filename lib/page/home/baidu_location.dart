// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:ui';
// import 'package:bmap_map_fluttify/bmap_map_fluttify.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:kqsc/page/home/loupan_page.dart';
// import 'package:kqsc/page/home/sousuo_page.dart';
// import 'package:kqsc/page/home_page.dart';
// import 'package:kqsc/page/shaixuan_page.dart';
// import 'package:kqsc/provider/app_provider.dart';
// import 'package:kqsc/provider/provider_config.dart';
// import 'package:kqsc/util/http.dart';
// import 'package:kqsc/widget/no_sliding_return.dart';
// import 'package:paixs_utils/model/data_model.dart';
// import 'package:paixs_utils/util/utils.dart';
// import 'package:paixs_utils/widget/anima_switch_widget.dart';
// import 'package:paixs_utils/widget/mytext.dart';
// import 'package:paixs_utils/widget/route.dart';
// import 'package:paixs_utils/widget/scaffold_widget.dart';
// import 'package:paixs_utils/widget/views.dart';
// import 'package:paixs_utils/widget/widget_tap.dart';
// import 'package:provider/provider.dart';
//
// import 'city_selecto.dart';
//
// class MapPage extends StatefulWidget {
//   final String latitude;
//   final String longitude;
//   final bool gesturesEnabled;
//   final bool isMove;
//   final Function onClickFun;
//   const MapPage({
//     Key key,
//     this.latitude,
//     this.longitude,
//     this.gesturesEnabled = true,
//     this.onClickFun,
//     this.isMove = true,
//   }) : super(key: key);
//   _MapPageState createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> with NoSlidingReturn, NextLatLng {
//   BmapController _controller;
//   bool flag = true;
//   List markers = [];
//
//   ///地区
//   var region;
//
//   ///户型
//   var layout;
//
//   ///总价
//   var totalPrice;
//
//   ///面积
//   var area;
//
//   @override
//   void initState() {
//     this.initData();
//     super.initState();
//   }
//
//   ///初始化函数
//   Future initData() async {
//     if (widget.gesturesEnabled) {
//       await this.getPageList(isRef: true);
//     } else {
//       loupanDm.flag = getTime();
//     }
//   }
//
//   @override
//   void dispose() {
//     flog('释放地图资源');
//     // _controller.dispose();
//     super.dispose();
//   }
//
//   ///楼盘列表
//   var loupanDm = DataModel(hasNext: false);
//   Future<int> getPageList({int page = 1, bool isRef = false}) async {
//     await Request.get(
//       '/api/Building/GetPageList',
//       data: {
//         "PageIndex": page,
//         "PageSize": 1000,
//         if (region != null) "Region": region,
//         if (totalPrice != null) "TotalPrice": totalPrice,
//         if (layout != null) "Layout": layout,
//         if (area != null) "Area": area,
//       },
//       catchError: (v) => loupanDm.toError(v),
//       success: (v) async {
//         loupanDm.addList(v['data'], isRef, v['total']);
//         if (loupanDm.list.isNotEmpty) {
//           _controller?.setCenterCoordinate(LatLng(
//             double.parse(loupanDm.list.first['position'].toString().split(',')[1]),
//             double.parse(loupanDm.list.first['position'].toString().split(',')[0]),
//           ));
//           _controller?.setZoomLevel(10);
//         } else {
//           showToast('暂无楼盘');
//         }
//         markers = loupanDm.list.map((obj) {
//           var latLng = '${obj['position']}'.split(',');
//           return MarkerOption(
//             latLng: LatLng(double.parse(latLng[1]), double.parse(latLng[0])),
//             object: obj['id'],
//             widget: Stack(
//               clipBehavior: Clip.none,
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Positioned(
//                   bottom: -2,
//                   child: Image.asset(
//                     'assets/img/sanjiao.png',
//                     width: 24,
//                     height: 24,
//                     color: Color(0xFF3988FF),
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   child: MyText('${obj['buildingName']}', color: Colors.white),
//                   margin: EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF3988FF),
//                     borderRadius: BorderRadius.circular(56),
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 4,
//                         color: Colors.black26,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList();
//         await Future.delayed(Duration(milliseconds: 500));
//         await _controller?.addMarkers(markers);
//         if (widget.gesturesEnabled) {
//           _controller?.setMarkerClickedListener((marker) async {
//             var object = await marker.object;
//             jumpPage(LoupanPage(data: {'id': object}, isZhaofang: true));
//             return false;
//           });
//         }
//       },
//     );
//     setState(() {});
//     return loupanDm.flag;
//   }
//
//   ///初始化控制器
//   Future<void> initController(BmapController controller) async {
//     _controller = controller;
//     if (Platform.isAndroid) _controller.androidController.showZoomControls(false);
//     if (Platform.isIOS) _controller.iosController.set_zoomEnabledWithTap(false);
//     if (loupanDm.list.isNotEmpty) {
//       _controller?.setCenterCoordinate(
//         widget.longitude == null
//             ? LatLng(
//                 double.parse(loupanDm.list.first['position'].toString().split(',')[1]),
//                 double.parse(loupanDm.list.first['position'].toString().split(',')[0]),
//               )
//             : LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
//       );
//       _controller.setZoomLevel(10);
//     } else {
//       _controller?.setCenterCoordinate(
//         widget.longitude == null ? app.latLng : LatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
//       );
//       _controller.setZoomLevel(18);
//     }
//     _controller.setRotateGesturesEnabled(false);
//     // _controller.setZoomGesturesEnabled(false);
//     _controller.setOverlookingGesturesEnabled(widget.gesturesEnabled);
//     _controller.setScrollGesturesEnabled(widget.gesturesEnabled);
//     // _controller?.setMapMoveListener(
//     //   onMapMoveEnd: (v) async{
//     //     showToast('msg');
//     //   }
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldWidget(
//       appBar: widget.gesturesEnabled
//           ? buildTitle(
//               context,
//               color: Colors.white,
//               title: '地图找房'
//             )
//           : null,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: AnimatedSwitchBuilder(
//               value: loupanDm,
//               animationTime: 500,
//               errorOnTap: null,
//               isCancelOtherState: true,
//               objectBuilder: (map) {
//                 return Container(
//                   height: double.infinity,
//                   child: Stack(
//                     children: [
//                       BmapView(
//                         onMapCreated: (controller) async {
//                           this.initController(controller);
//                         },
//                       ),
//                       Positioned(
//                         left: 0,
//                         bottom: 0,
//                         top: 0,
//                         child: Container(width: 16, color: Colors.transparent),
//                       ),
//                       Positioned(
//                         right: 0,
//                         bottom: 0,
//                         top: 0,
//                         child: Container(width: 16, color: Colors.transparent),
//                       ),
//                       Center(
//                         child: Container(
//                           height: 24,
//                           width: 24,
//                           alignment: Alignment.center,
//                           child: ClipOval(
//                             child: Container(
//                               height: 12,
//                               width: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).primaryColor,
//                             borderRadius: BorderRadius.circular(24),
//                             boxShadow: [
//                               BoxShadow(
//                                 blurRadius: 4,
//                                 color: Colors.black26,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           if (widget.gesturesEnabled)
//             Positioned.fill(child: HomeSelectoWidget(fun: (v) async {
//               flog(v);
//               region = v['quyu'];
//               totalPrice = v['zongjia'];
//               layout = v['huxing'];
//               area = v['jianzhu'];
//               _controller?.clear();
//               buildShowDialog(context);
//               await this.getPageList(isRef: true);
//               close();
//             })),
//           // if (!widget.gesturesEnabled)
//           //   Container(
//           //     color: Colors.transparent,
//           //   ),
//         ],
//       ),
//     );
//   }
//
//   Container buildMapTitle(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.only(top: padd(context).top + 8, left: 8, right: 8, bottom: 8),
//       child: Row(
//         children: [
//           WidgetTap(
//             isElastic: true,
//             onTap: () => close(),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Icon(Icons.close_rounded, size: 20),
//             ),
//           ),
//           Expanded(child: Center(child: MyText('地图找房')))
//           // Expanded(
//           //   child: WidgetTap(
//           //     onTap: () {
//           //       jumpPage(SousuoPage(isZhaofang: true));
//           //     },
//           //     child: Container(
//           //       alignment: Alignment.center,
//           //       padding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
//           //       decoration: BoxDecoration(
//           //         borderRadius: BorderRadius.circular(56),
//           //         color: Color(0xffF5F5F5),
//           //       ),
//           //       child: Row(
//           //         children: [
//           //           WidgetTap(
//           //             isElastic: true,
//           //             onTap: () {
//           //               jumpPage(PhoneCountryCodePage(), callback: (v) {});
//           //             },
//           //             child: Container(
//           //               padding: EdgeInsets.symmetric(vertical: 8),
//           //               child: Row(
//           //                 children: [
//           //                   Padding(
//           //                     padding: EdgeInsets.only(top: 2),
//           //                     child: Image.asset(
//           //                       'assets/img/home_dingwei.png',
//           //                       width: 13,
//           //                       height: 13,
//           //                     ),
//           //                   ),
//           //                   SizedBox(width: 9),
//           //                   Selector<AppProvider, String>(
//           //                     selector: (_, k) => k.city,
//           //                     builder: (_, v, view) => MyText(v ?? '请稍后', size: 13),
//           //                   ),
//           //                   SizedBox(width: 16),
//           //                   Container(
//           //                     height: 18,
//           //                     width: 1,
//           //                     color: Colors.black12,
//           //                   ),
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //           SizedBox(width: 16),
//           //           Image.asset(
//           //             'assets/img/home_sousuo.png',
//           //             width: 13,
//           //             height: 13,
//           //           ),
//           //           SizedBox(width: 11),
//           //           Expanded(
//           //             child: MyText(
//           //               '请输入关键词搜索',
//           //               size: 13,
//           //               color: Color(0xffB7B7B7),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
// mixin NextLatLng {
//   final random = Random();
//   LatLng getNextLatLng({LatLng center}) {
//     center ??= LatLng(39.90960, 116.397228);
//     return LatLng(
//       center.latitude + random.nextDouble(),
//       center.longitude + random.nextDouble(),
//     );
//   }
//
//   List<LatLng> getNextBatchLatLng(int count) {
//     return [
//       for (int i = 0; i < count; i++)
//         LatLng(
//           app.latLng.latitude - random.nextDouble() / 100,
//           app.latLng.longitude + random.nextDouble() / 100,
//         )
//     ];
//   }
// }
