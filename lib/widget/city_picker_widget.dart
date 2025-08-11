import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paixs_utils/util/utils.dart';
import 'dart:convert';

import 'package:paixs_utils/widget/media/CPicker_widget.dart';

typedef void ChangeData(Map<String, dynamic> map);
typedef List<Widget> CreateWidgetList();

class CityPicker {
  static void showCityPicker(
    BuildContext context, {
    ChangeData? selectProvince,
    ChangeData? selectCity,
    ChangeData? selectArea,
    ChangeData? selectAll,
  }) {
    rootBundle.loadString('data/province.json').then((v) {
      List data = json.decode(v);
      Navigator.push(
        context,
        _CityPickerRoute(data: data, selectProvince: selectProvince!,
            selectCity: selectCity!, selectArea: selectArea!, selectAll:
            selectAll!, theme: Theme.of(context), barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel),
      );
    });
  }
}

class _CityPickerRoute<T> extends PopupRoute<T> {
  final ThemeData? theme;
  final String? barrierLabel;
  final List? data;
  final ChangeData? selectProvince;
  final ChangeData? selectCity;
  final ChangeData? selectArea;
  final ChangeData? selectAll;
  _CityPickerRoute({
    this.theme,
    this.barrierLabel,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.selectAll,
  });

  @override
  Duration get transitionDuration => Duration(milliseconds: 2000);

  @override
  @override
  Color get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator?.overlay as TickerProvider);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: _CityPickerWidget(
        route: this,
        data: data!,
        selectProvince: selectProvince!,
        selectCity: selectCity!,
        selectArea: selectArea!,
        selectAll: selectAll!,
      ),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }
    return bottomSheet;
  }
}

class _CityPickerWidget extends StatefulWidget {
  final _CityPickerRoute route;
  final List? data;
  final ChangeData? selectProvince;
  final ChangeData? selectCity;
  final ChangeData? selectArea;
  final ChangeData? selectAll;

  _CityPickerWidget({
    // ignore: unused_element
    Key? key,
    required this.route,
    this.data,
    this.selectProvince,
    this.selectCity,
    this.selectArea,
    this.selectAll,
  });

  @override
  State createState() {
    return _CityPickerState();
  }
}

class _CityPickerState extends State<_CityPickerWidget> {
  FixedExtentScrollController? provinceController;
  FixedExtentScrollController? cityController;
  FixedExtentScrollController? areaController;
  int provinceIndex = 0, cityIndex = 0, areaIndex = 0;
  List province = [];
  List city = [];
  List area = [];

  @override
  void initState() {
    super.initState();
    provinceController = FixedExtentScrollController();
    cityController = FixedExtentScrollController();
    areaController = FixedExtentScrollController();
    if (mounted)
      setState(() {
        province = widget.data!;
        city = widget.data![provinceIndex]['cities'];
        area = widget.data![provinceIndex]['cities'][cityIndex]['district'];
      });
  }

  Widget _bottomView() {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context!),
                      child: Text(
                        '取消',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xff999999),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Map<String, dynamic> provinceMap = {"code": province[provinceIndex]['provinceid'], "name": province[provinceIndex]['province']};
                        Map<String, dynamic> cityMap = {"code": province[provinceIndex]['cities'][cityIndex]['cityid'], "name": province[provinceIndex]['cities'][cityIndex]['city']};
                        Map<String, dynamic> areaMap = {"code": province[provinceIndex]['cities'][cityIndex]['district'][areaIndex]['areaid'], "name": province[provinceIndex]['cities'][cityIndex]['district'][areaIndex]['area']};
                        Map<String, dynamic> allMap = {"name": province[provinceIndex]['province'] + province[provinceIndex]['cities'][cityIndex]['city'] + province[provinceIndex]['cities'][cityIndex]['district'][areaIndex]['area']};

                        if (widget.selectProvince != null) {
                          widget.selectProvince!(provinceMap);
                        }
                        if (widget.selectCity != null) {
                          widget.selectCity!(cityMap);
                        }
                        if (widget.selectArea != null) {
                          widget.selectArea!(areaMap);
                        }

                        if (widget.selectAll != null) {
                          widget.selectAll!(allMap);
                        }

                        Navigator.pop(context!);
                      },
                      child: Text(
                        '确认',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context!).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    _MyCityPicker(
                      key: Key('province'),
                      controller: provinceController!,
                      createWidgetList: () {
                        return province.map((v) {
                          return Align(
                            child: Text(
                              v['province'],
                              textScaleFactor: 1.2,
                              maxLines: 1,
                              style: TextStyle(fontSize: 14),
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                      changed: (index) {
                        if (mounted)
                          setState(() {
                            provinceIndex = index;
                            cityIndex = 0;
                            areaIndex = 0;
                            cityController!.jumpToItem(0);
                            areaController!.jumpToItem(0);
                            city = widget.data![provinceIndex]['cities'];
                            area = widget
                                .data![provinceIndex]['cities'][cityIndex]['district'];
                          });
                      },
                    ),
                    _MyCityPicker(
                      key: Key('city'),
                      controller: cityController!,
                      createWidgetList: () {
                        return city.map((v) {
                          return Align(
                            child: Text(
                              v['city'],
                              textScaleFactor: 1.2,
                              maxLines: 1,
                              style: TextStyle(fontSize: 14),
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                      changed: (index) {
                        if (mounted)
                          setState(() {
                            cityIndex = index;
                            areaIndex = 0;
                            areaController!.jumpToItem(0);
                            area = widget
                                .data![provinceIndex]['cities'][cityIndex]['district'];
                          });
                      },
                    ),
                    _MyCityPicker(
                      key: Key('area'),
                      controller: areaController!,
                      createWidgetList: () {
                        return area.map((v) {
                          return Align(
                            child: Text(
                              v['area'],
                              maxLines: 1,
                              textScaleFactor: 1.2,
                              style: TextStyle(fontSize: 14),
                            ),
                            alignment: Alignment.center,
                          );
                        }).toList();
                      },
                      changed: (index) {
                        if (mounted)
                          setState(() {
                            areaIndex = index;
                          });
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedBuilder(
        animation: CurvedAnimation(
          parent: widget.route.animation!,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeOutCubic,
        ),
        builder: (BuildContext context, Widget? child) {
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                CurvedAnimation(
                  parent: widget.route.animation!,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeOutCubic,
                ).value,
              ),
              child: GestureDetector(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: double.infinity,
                    height: 260.0,
                    child: _bottomView(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MyCityPicker extends StatefulWidget {
  final CreateWidgetList? createWidgetList;
  final Key? key;
  final FixedExtentScrollController? controller;
  final ValueChanged<int>? changed;

  _MyCityPicker({this.createWidgetList, this.key, this.controller, this.changed});

  @override
  State createState() {
    return _MyCityPickerState();
  }
}

class _MyCityPickerState extends State<_MyCityPicker> {
  List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(6.0),
        alignment: Alignment.center,
        height: 220.0,
        child: CPickerWidget(
          backgroundColor: Colors.white,
          scrollController: widget.controller,
          key: widget.key,
          itemExtent: 30.0,
          onSelectedItemChanged: (index) {
            if (widget.changed != null) {
              widget.changed!(index);
            }
          },
          children: widget.createWidgetList!().length > 0 ? widget
              .createWidgetList!() : [Text('')],
        ),
      ),
      flex: 1,
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(this.progress, {this.itemCount, this.showTitleActions});

  final double progress;
  final int? itemCount;
  final bool? showTitleActions;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = 300.0;

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    double height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
