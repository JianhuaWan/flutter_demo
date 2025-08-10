import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/phone_country_code_data.dart';
import 'package:flutter_app/provider/app_provider.dart';
import 'package:flutter_app/provider/provider_config.dart';
import 'package:flutter_app/view/views.dart';
import 'package:flutter_app/widget/tween_widget.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:paixs_utils/widget/animation/anima_switch_widget.dart';
import 'package:paixs_utils/widget/form/mytext.dart';
import 'package:paixs_utils/widget/interaction/widget_tap.dart';
import 'package:paixs_utils/widget/layout/views.dart';
import 'package:paixs_utils/widget/navigation/route.dart';
import 'package:paixs_utils/widget/layout/scaffold_widget.dart';
import 'package:paixs_utils/widget/refresh/mylistview.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneCountryCodePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PageState();
}

class PageState extends State<PhoneCountryCodePage> {
  List<String> letters = [
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'J',
    'K',
    'L',
    'M',
    'N',
    'P',
    'R',
    'S',
    'T',
    'W',
    'X',
    'Y',
    'Z'
  ];
  ScrollController _scrollController = ScrollController();
  double? value;
  bool flag = false;
  String? editText;
  var sousuoResult = [];
  TextEditingController textCon = TextEditingController();

  var text;

  @override
  void initState() {
    RouteState.isSlideRight = false;
    super.initState();
    getPhoneCodeDataList();
  }

  @override
  void dispose() {
    RouteState.isSlideRight = true;
    super.dispose();
  }

  var cityDm = DataModel<List<PhoneCountryCodeData>>(object: []);

  Future getPhoneCodeDataList() async {
    var sp = await SharedPreferences.getInstance();
    app.sousuoList = sp.getStringList('sousuoList') ?? [];
    if (app.shengshiquDm.object == null) await app.getDropDownList(false);
    
    // 创建一个临时列表来存储有数据的字母
    List<String> lettersWithData = [];
    
    letters.forEach((f) {
      var listData = app.shengshiquDm.object!.where((w) {
        return w['code'] == (f == '#' ? null : f);
      }).map((e) {
        return PhoneCountryCodeDataListdata(
            code: e['code'], name: e['name'], id: int.parse(e['id']));
      }).toList();
      
      // 只有当该字母下有数据时才添加
      if (listData.isNotEmpty) {
        cityDm.object!.add(
          PhoneCountryCodeData(
            name: f,
            listData: listData,
          ),
        );
        lettersWithData.add(f);
      }
    });
    
    this.setState(() {
      cityDm.object!.insert(
        0,
        PhoneCountryCodeData.fromJson({
          "listData": [],
          "name": "热门城市",
        }),
      );
      cityDm.object!.insert(
        0,
        PhoneCountryCodeData.fromJson({
          "listData": [],
          "name": "历史记录",
        }),
      );
      
      // 更新letters列表，只保留有数据的字母加上"历史记录"和"热门城市"
      letters.clear();
      letters.addAll(lettersWithData);
      letters.insert(0, '热');
      letters.insert(0, '历');
      
      value = (size(context).height - 112 - 100 - padd(context).top) /
          letters.length;
      cityDm.setTime();
    });
  }

  void suggestionSearch(v) async {
    var where = app.shengshiquDm.object!.where((f) {
      return (f['name'].toString().indexOf(v) == 0);
    }).toList();
    setState(() {
      sousuoResult = where;
      editText = v == 'null' ? null : v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      resizeToAvoidBottomInset: false,
      appBar: SousuoAppbar(
        onSubmitted: (v) => this.suggestionSearch(v == '' ? 'null' : v),
        textCon: textCon,
      ),
      body: Stack(
        children: [
          AnimatedSwitchBuilder<List<PhoneCountryCodeData>>(
            value: cityDm,
            errorOnTap: () => this.getPhoneCodeDataList(),
            objectBuilder: (obj) {
              return Stack(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    itemCount: obj.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // 检查是否是历史记录或热门城市（这些总是显示）
                      bool isSpecialSection = index < 2;
                      // 检查是否是字母分组且有数据
                      bool hasData = isSpecialSection || 
                          (index < obj.length && obj[index].listData!.isNotEmpty);
                    
                      // 如果不是特殊部分且没有数据，则不显示该项
                      if (!isSpecialSection && !hasData) {
                        return SizedBox.shrink(); // 返回一个空的widget
                      }
                    
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // 只有在有数据时才显示字母索引名称
                          if (hasData) 
                            PhoneCodeIndexName(obj[index].name!.toUpperCase()),
                          if (index == 0 && hasData)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Selector<AppProvider, int>(
                                selector: (_, k) => k.sousuoList.length,
                                builder: (_, v, view) {
                                  return Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: List.generate(
                                        app.sousuoList.length, (i) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            editText = app.sousuoList[i];
                                            textCon.text = editText!;
                                          });
                                        },
                                        child: Container(
                                          height: 30,
                                          width: size(context).width / 3 -
                                              (30 + 32) / 3,
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8),
                                          alignment: Alignment.center,
                                          child: MyText(app.sousuoList[i],
                                              size: 12, isBold: true),
                                        ),
                                      );
                                    }),
                                  );
                                },
                              ),
                            )
                          else if (index == 1 && hasData)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: List.generate(
                                    [
                                      '东莞',
                                      '惠州',
                                      '深圳',
                                      '中山',
                                      '广州',
                                      '佛山',
                                      '肇庆',
                                      '珠海'
                                    ].length, (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      showTc(
                                        title: '确定切换到${[
                                          '东莞',
                                          '惠州',
                                          '深圳',
                                          '中山',
                                          '广州',
                                          '佛山',
                                          '肇庆',
                                          '珠海'
                                        ][i]}吗？',
                                        onPressed: () {
                                          ///东莞，惠州，深圳，中山，广州，佛山，肇庆，珠海
                                          app.city = [
                                            '东莞',
                                            '惠州',
                                            '深圳',
                                            '中山',
                                            '广州',
                                            '佛山',
                                            '肇庆',
                                            '珠海',
                                          ][i];
                                          app.cityCode = [
                                            '441900',
                                            '441300',
                                            '440300',
                                            '442000',
                                            '440100',
                                            '440600',
                                            '441200',
                                            '440400'
                                          ][i];
                                          app.setState();
                                          Navigator.of(context).pop([
                                            '东莞',
                                            '惠州',
                                            '深圳',
                                            '中山',
                                            '广州',
                                            '佛山',
                                            '肇庆',
                                            '珠海'
                                          ][i]);
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 30,
                                      width: size(context).width / 3 -
                                          (30 + 32) / 3,
                                      color: Colors.white,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      alignment: Alignment.center,
                                      child: MyText(
                                          [
                                            '东莞',
                                            '惠州',
                                            '深圳',
                                            '中山',
                                            '广州',
                                            '佛山',
                                            '肇庆',
                                            '珠海'
                                          ][i],
                                          size: 12,
                                          isBold: true),
                                    ),
                                  );
                                }),
                              ),
                            )
                          else if (hasData)
                            Container(
                              color: Colors.white,
                              child: MyListView(
                                isShuaxin: false,
                                flag: !false,
                                itemCount: obj[index].listData!.length,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                listViewType: ListViewType.Separated,
                                physics: NeverScrollableScrollPhysics(),
                                divider: Divider(height: 0),
                                item: (i) {
                                  return GestureDetector(
                                    onTap: () {
                                      showTc(
                                        title:
                                            '确定切换到${obj[index].listData![i].name}吗？',
                                        onPressed: () {
                                          app.city =
                                              obj[index].listData![i].name;
                                          app.cityCode = obj[index]
                                              .listData![i]
                                              .id
                                              .toString();
                                          app.setState();
                                          Navigator.of(context).pop(
                                              obj[index].listData![i].toJson());
                                        },
                                      );
                                    },
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(
                                      height: 46,
                                      alignment: Alignment.centerLeft,
                                      child: MyText(
                                        "${obj[index].listData![i].name}",
                                        size: 16,
                                        isBold: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  if (flag)
                    TweenWidget(
                      axis: Axis.vertical,
                      delayed: 100,
                      curve: ElasticOutCurve(1),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(56),
                          child: Container(
                            color: Colors.black.withOpacity(0.75),
                            width: 56,
                            height: 56,
                            alignment: Alignment.center,
                            child: Selector<AppProvider, String>(
                              selector: (_, k) => k.cityListIndex,
                              builder: (_, v, view) {
                                return getTime() % 2 != 0
                                    ? TweenWidget(
                                        key: ValueKey(1),
                                        axis: Axis.vertical,
                                        isScale: true,
                                        value: -100,
                                        curve: ElasticOutCurve(1),
                                        child: MyText(v,
                                            color: Colors.white,
                                            size: 24,
                                            isBold: true),
                                      )
                                    : TweenWidget(
                                        key: ValueKey(2),
                                        isScale: true,
                                        axis: Axis.vertical,
                                        curve: ElasticOutCurve(1),
                                        child: MyText(v,
                                            color: Colors.white,
                                            size: 24,
                                            isBold: true),
                                      );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    top: 56,
                    bottom: 56,
                    child: Listener(
                      onPointerDown: (v) {
                        setState(() => flag = true);
                      },
                      onPointerUp: (v) {
                        setState(() => flag = false);
                      },
                      onPointerMove: (v) {
                        try {
                          int ii = v.localPosition.dy ~/ value!;
                          app.changeCityListIndex(letters[ii]);
                          if (ii == letters.length - 1 ||
                              ii > letters.length - 1) {
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          } else {
                            if (ii >= 0) {
                              if (ii == 0) {
                                _scrollController.jumpTo(0);
                              } else if (ii == 1) {
                                if (app.sousuoList.isEmpty) {
                                  _scrollController.jumpTo(45);
                                } else {
                                  var ceil = (app.sousuoList.length / 3).ceil();
                                  var height =
                                      45.0 + ceil * 30 + (ceil - 1) * 16;
                                  _scrollController.jumpTo(height);
                                }
                              } else {
                                if (app.sousuoList.isEmpty) {
                                  var height = ii * 45.0;
                                  for (int i = 0; i < ii; i++) {
                                    height += obj[i].listData!.length * 46.0;
                                  }
                                  var ceil = (app.sousuoList.length / 3).ceil();
                                  var value = 45.0 +
                                      ceil * 30 +
                                      (ceil - 1) * 16 +
                                      1 +
                                      46;
                                  _scrollController.jumpTo(height + value);
                                } else {
                                  var height = ii * 45.0;
                                  for (int i = 0; i < ii; i++) {
                                    height += obj[i].listData!.length * 46.0;
                                  }
                                  var ceil = (app.sousuoList.length / 3).ceil();
                                  var value = 45.0 +
                                      ceil * 30 +
                                      (ceil - 1) * 16 -
                                      15 +
                                      46;
                                  _scrollController.jumpTo(height + value);
                                }
                              }
                            }
                          }
                        } catch (e) {}
                      },
                      child: Column(
                        children: List.generate(letters.length, (ii) {
                          // 检查是否应该显示该字母（历史记录和热门城市总是显示）
                          bool shouldShowLetter = ii < 2; // 历史记录和热门城市总是显示
                          if (!shouldShowLetter && ii < letters.length) {
                            // 检查对应字母是否有数据
                            int dataIndex = ii; // 对应主列表中的索引
                            if (dataIndex < obj.length) {
                              shouldShowLetter = obj[dataIndex].listData!.isNotEmpty;
                            }
                          }
                          
                          if (!shouldShowLetter) {
                            return SizedBox.shrink();
                          }
                          
                          return Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                color: Colors.transparent,
                                width: 32,
                                alignment: Alignment.center,
                                child: TweenWidget(
                                    delayed: 20 + 10 * ii,
                                    axis: Axis.vertical,
                                    child: MyText(letters[ii], isBold: true)),
                              ),
                              onTapDown: (v) {
                                app.changeCityListIndex(letters[ii]);
                              },
                              onTap: () {
                                if (ii == letters.length - 1 ||
                                    ii > letters.length - 1) {
                                  _scrollController.jumpTo(_scrollController
                                      .position.maxScrollExtent);
                                } else {
                                  if (ii >= 0) {
                                    if (ii == 0) {
                                      _scrollController.jumpTo(0);
                                    } else if (ii == 1) {
                                      if (app.sousuoList.isEmpty) {
                                        _scrollController.jumpTo(45);
                                      } else {
                                        var ceil =
                                            (app.sousuoList.length / 3).ceil();
                                        var height =
                                            45.0 + ceil * 30 + (ceil - 1) * 16;
                                        _scrollController.jumpTo(height);
                                      }
                                    } else {
                                      if (app.sousuoList.isEmpty) {
                                        var height = ii * 45.0;
                                        for (int i = 2; i < ii; i++) { // 从2开始因为前两个是特殊项
                                          if (i < obj.length) {
                                            height += obj[i].listData!.length * 46.0;
                                          }
                                        }
                                        var ceil =
                                            (app.sousuoList.length / 3).ceil();
                                        var value = 45.0 +
                                            ceil * 30 +
                                            (ceil - 1) * 16 +
                                            1 +
                                            46;
                                        _scrollController
                                            .jumpTo(height + value);
                                      } else {
                                        var height = ii * 45.0;
                                        for (int i = 2; i < ii; i++) { // 从2开始因为前两个是特殊项
                                          if (i < obj.length) {
                                            height += obj[i].listData!.length * 46.0;
                                          }
                                        }
                                        var ceil =
                                            (app.sousuoList.length / 3).ceil();
                                        var value = 45.0 +
                                            ceil * 30 +
                                            (ceil - 1) * 16 -
                                            15 +
                                            46;
                                        _scrollController
                                            .jumpTo(height + value);
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          if (editText != null || sousuoResult.isNotEmpty)
            Positioned.fill(
              child: Container(
                color: Colors.white,
                child: MyListView(
                  isShuaxin: false,
                  itemCount: sousuoResult.length,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  listViewType: ListViewType.Separated,
                  physics: BouncingScrollPhysics(),
                  divider: Divider(height: 0),
                  item: (i) {
                    return GestureDetector(
                      onTap: () async {
                        var app = context.read<AppProvider>();
                        // 修复：先检查列表是否为空，再检查元素是否存在
                        bool itemExists = app.sousuoList.isNotEmpty &&
                            app.sousuoList.indexOf(sousuoResult[i]['name']) !=
                                -1;
                        if (!itemExists) {
                          app.sousuoList.insert(0, sousuoResult[i]['name']);
                        } else {
                          app.sousuoList.remove(sousuoResult[i]['name']);
                          app.sousuoList.insert(0, sousuoResult[i]['name']);
                        }
                        var sp = await SharedPreferences.getInstance();
                        await sp.setStringList('sousuoList', app.sousuoList);
                        showTc(
                          title: '确定切换到${sousuoResult[i]['name']}吗？',
                          onPressed: () {
                            app.city = sousuoResult[i]['name'];
                            app.cityCode = sousuoResult[i]['id'];
                            app.setState();
                            Navigator.of(context).pop(sousuoResult[i]);
                          },
                        );
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        height: 46,
                        alignment: Alignment.centerLeft,
                        child: MyText(
                          sousuoResult[i]['name'],
                          size: 16,
                          isBold: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PhoneCodeIndexName extends StatelessWidget {
  final String indexName;

  const PhoneCodeIndexName(this.indexName, {Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      height: 45,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Expanded(child: MyText(indexName, color: Color(0xff434343))),
          if (indexName == '历史记录')
            WidgetTap(
              isElastic: true,
              onTap: () => app.clearSousuoList(),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.delete, size: 16),
              ),
            ),
        ],
      ),
    );
  }
}

class SousuoAppbar extends StatefulWidget {
  final Function(dynamic)? onSubmitted;
  final String? text;
  final TextEditingController? textCon;

  const SousuoAppbar({Key? key, this.onSubmitted, this.text, this.textCon})
      : super(key: key);

  @override
  _SousuoAppbarState createState() => _SousuoAppbarState();
}

class _SousuoAppbarState extends State<SousuoAppbar> {
  TextEditingController textCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 100 + padd(context).top,
      child: Column(
        children: [
          SizedBox(height: padd(context).top),
          SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/img/home_search.png',
                            width: 13, height: 13),
                        SizedBox(width: 10),
                        buildTFView(
                          context,
                          hintText: '请输入关键词搜索',
                          isExp: true,
                          con: widget.textCon ?? textCon,
                          onSubmitted: (v) async {
                            var app = context.read<AppProvider>();
                            if ((widget.textCon ?? textCon).text == '') {
                            } else {
                              // 修复：先检查列表是否为空，再检查元素是否存在
                              bool itemExists = app.sousuoList.isNotEmpty &&
                                  app.sousuoList.indexOf(
                                          (widget.textCon ?? textCon).text) !=
                                      -1;
                              if (!itemExists) {
                                app.sousuoList.insert(
                                    0, (widget.textCon ?? textCon).text);
                              } else {
                                app.sousuoList
                                    .remove((widget.textCon ?? textCon).text);
                                app.sousuoList.insert(
                                    0, (widget.textCon ?? textCon).text);
                              }
                              var sp = await SharedPreferences.getInstance();
                              await sp.setStringList(
                                  'sousuoList', app.sousuoList);
                            }
                          },
                          onChanged: (v) {
                            widget.onSubmitted!(v);
                            // this.setState(() {});
                          },
                          hintColor: Color(0xFFB7B7B7),
                          hintSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                WidgetTap(
                  onTap: () async {
                    var app = context.read<AppProvider>();
                    widget.onSubmitted?.call((widget.textCon ?? textCon).text);
                    if ((widget.textCon ?? textCon).text == '') {
                      close();
                    } else {
                      // 修复：先检查列表是否为空，再检查元素是否存在
                      bool itemExists = app.sousuoList.isNotEmpty &&
                          app.sousuoList
                                  .indexOf((widget.textCon ?? textCon).text) !=
                              -1;
                      if (!itemExists) {
                        app.sousuoList
                            .insert(0, (widget.textCon ?? textCon).text);
                      } else {
                        app.sousuoList.remove((widget.textCon ?? textCon).text);
                        app.sousuoList
                            .insert(0, (widget.textCon ?? textCon).text);
                      }
                      var sp = await SharedPreferences.getInstance();
                      await sp.setStringList('sousuoList', app.sousuoList);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 16, top: 8, bottom: 8),
                    child: MyText(
                      (widget.textCon ?? textCon).text == '' ? '取消' : '搜索',
                      color: (widget.textCon ?? textCon).text == ''
                          ? Color(0xFFB7B7B7)
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Selector<AppProvider, String>(
                      selector: (_, k) => k.city ?? '',
                      builder: (_, v, view) {
                        return MyText(
                          v ?? '请稍后',
                          isBold: true,
                          children: [
                            MyText.ts(
                              '\t\tGPS定位',
                              color: Color(0xFF999999),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 19,
                    width: 1,
                    margin: EdgeInsets.symmetric(horizontal: 14),
                    color: Colors.black12,
                  ),
                  WidgetTap(
                    isElastic: true,
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 1000));
                      close('1');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: MyText(
                        '重新定位',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
