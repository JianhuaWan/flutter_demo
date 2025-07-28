import 'package:flutter/material.dart';
import 'package:kqsc/widget/lazy_data_table.dart' as paixs;
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/anima_switch_widget.dart';
import 'package:paixs_utils/widget/mytext.dart';
import 'package:paixs_utils/widget/refresher_widget.dart';

///表格
class DataTableWidget extends StatelessWidget {
  const DataTableWidget({
    Key key,
    @required this.dataModel,
    this.onLoading,
    this.errorOnTap,
    this.onRefresh,
    this.columnHeader,
    this.dataCellBuilder,
  }) : super(key: key);

  final DataModel dataModel;
  final void Function() errorOnTap;
  final Future<int> Function(int) onLoading;
  final Future<int> Function() onRefresh;
  final List columnHeader;
  final dynamic Function(List, int, int) dataCellBuilder;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitchBuilder(
      value: dataModel,
      errorOnTap: () => errorOnTap(),
      listBuilder: (list, p, h) {
        return RefresherWidget(
          isGengduo: h,
          onLoading: () => onLoading(p),
          onRefresh: () => onRefresh(),
          child: paixs.LazyDataTable(
            rows: list.length,
            columns: columnHeader == null ? ['变电站名称', '组织机构', '区域', '地址', '创建时间'].length : columnHeader.length,
            tableDimensions: LazyDataTableDimensions(
              cellHeight: 32,
              cellWidth: 150,
              columnHeaderHeight: 32,
            ),
            tableTheme: LazyDataTableTheme(
              alternateCellColor: Theme.of(context).primaryColor.withOpacity(0.1),
              columnHeaderColor: Theme.of(context).primaryColor,
              alternateCellBorder: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05), width: 0.5),
              cellBorder: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.05), width: 0.5),
              columnHeaderBorder: Border.all(color: Colors.white24, width: 0.5),
            ),
            columnHeaderBuilder: (i) => Center(
              child: MyText(
                columnHeader ?? ['变电站名称', '组织机构', '区域', '地址', '创建时间'][i],
                color: Colors.white,
                size: 12,
              ),
            ),
            dataCellBuilder: (i, j) => Center(
              child: MyText(
                dataCellBuilder.call(list, i, j),
                isOverflow: false,
                size: 12,
                color: Color(0xff606266),
              ),
            ),
          ),
        );
      },
    );
  }
}
