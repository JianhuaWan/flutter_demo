import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/scheduler.dart';
import 'package:lazy_data_table/lazy_data_table.dart';

class LazyDataTable extends StatefulWidget {
  LazyDataTable({
    Key key,
    @required this.columns,
    @required this.rows,
    this.tableDimensions = const LazyDataTableDimensions(),
    this.tableTheme = const LazyDataTableTheme(),
    this.columnHeaderBuilder,
    this.rowHeaderBuilder,
    @required this.dataCellBuilder,
    this.cornerWidget,
  }) : super(key: key) {
    assert(columns != null);
    assert(rows != null);
    assert(dataCellBuilder != null);
    if (rowHeaderBuilder == null || columnHeaderBuilder == null) {
      assert(cornerWidget == null, "The corner widget is only allowed when you have both a column header and a row header.");
    }
  }

  final table = _LazyDataTableState();

  final int columns;

  final int rows;

  final LazyDataTableDimensions tableDimensions;

  final LazyDataTableTheme tableTheme;

  final Widget Function(int columnIndex) columnHeaderBuilder;

  final Widget Function(int rowIndex) rowHeaderBuilder;

  final Widget Function(int columnIndex, int rowIndex) dataCellBuilder;

  final Widget cornerWidget;

  @override
  _LazyDataTableState createState() => table;

  void jumpToCell(int column, int row) {
    table.jumpToCell(column, row);
  }

  void jumpTo(double x, double y) {
    table.jumpTo(x, y);
  }
}

class _LazyDataTableState extends State<LazyDataTable> with TickerProviderStateMixin {
  _CustomScrollController _horizontalControllers;
  _CustomScrollController _verticalControllers;

  @override
  void initState() {
    super.initState();

    _horizontalControllers = _CustomScrollController(this);
    _verticalControllers = _CustomScrollController(this);
  }

  @override
  void dispose() {
    _horizontalControllers.dispose();
    _verticalControllers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // onPointerSignal: (pointerSignal) {
      //   if (pointerSignal is PointerScrollEvent) {
      //     jump(pointerSignal.scrollDelta.dx, pointerSignal.scrollDelta.dy);
      //   }
      // },
      // child: GestureDetector(
      //   onPanUpdate: (DragUpdateDetails details) {
      //     jump(-details.delta.dx, -details.delta.dy);
      //   },
      //   onPanEnd: (DragEndDetails details) {
      //     _verticalControllers
      //         .setVelocity(-details.velocity.pixelsPerSecond.dy / 100);
      //     _horizontalControllers
      //         .setVelocity(-details.velocity.pixelsPerSecond.dx / 100);
      //   },
      child: Row(
        children: <Widget>[
          widget.rowHeaderBuilder != null
              ? SizedBox(
                  width: widget.tableDimensions.rowHeaderWidth,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: widget.tableDimensions.columnHeaderHeight,
                        width: widget.tableDimensions.rowHeaderWidth,
                        child: widget.cornerWidget != null
                            ? Container(
                                decoration: widget.tableTheme.corner,
                                child: widget.cornerWidget,
                              )
                            : Container(),
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          controller: _verticalControllers,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.rows,
                          itemBuilder: (__, i) {
                            return Container(
                              height: widget.tableDimensions.customCellHeight.containsKey(i) ? widget.tableDimensions.customCellHeight[i] : widget.tableDimensions.cellHeight,
                              width: widget.tableDimensions.rowHeaderWidth,
                              decoration: widget.tableTheme.rowHeader,
                              child: widget.rowHeaderBuilder(i),
                            );
                          }),
                    ],
                  ),
                )
              : Container(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.columnHeaderBuilder != null
                  ? SizedBox(
                      height: widget.tableDimensions.columnHeaderHeight,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          controller: _horizontalControllers,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: widget.columns,
                          itemBuilder: (__, i) {
                            return Container(
                              height: widget.tableDimensions.columnHeaderHeight,
                              width: widget.tableDimensions.customCellWidth.containsKey(i) ? widget.tableDimensions.customCellWidth[i] : widget.tableDimensions.cellWidth,
                              decoration: widget.tableTheme.columnHeader,
                              child: widget.columnHeaderBuilder(i),
                            );
                          }),
                    )
                  : Container(),
              Container(
                height: 500,
                width: widget.tableDimensions.cellWidth * widget.columns,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: !true,
                    controller: _verticalControllers,
                    itemCount: widget.rows,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      return SizedBox(
                        height: widget.tableDimensions.customCellHeight.containsKey(i) ? widget.tableDimensions.customCellHeight[i] : widget.tableDimensions.cellHeight,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: !true,
                            controller: _horizontalControllers,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.columns,
                            itemBuilder: (__, j) {
                              return Container(
                                height: widget.tableDimensions.customCellHeight.containsKey(i) ? widget.tableDimensions.customCellHeight[i] : widget.tableDimensions.cellHeight,
                                width: widget.tableDimensions.customCellWidth.containsKey(j) ? widget.tableDimensions.customCellWidth[j] : widget.tableDimensions.cellWidth,
                                decoration: (widget.tableTheme.alternateRow && i % 2 != 0) || (widget.tableTheme.alternateColumn && j % 2 != 0) ? widget.tableTheme.alternateCell : widget.tableTheme.cell,
                                child: widget.dataCellBuilder(i, j),
                              );
                            }),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
      // ),
    );
  }

  void jumpToCell(int column, int row) {
    double customWidth = 0;
    int customWidthCells = 0;
    for (int i = 0; i < column; i++) {
      if (widget.tableDimensions.customCellWidth.containsKey(i)) {
        customWidth += widget.tableDimensions.customCellWidth[i];
        customWidthCells++;
      }
    }
    _horizontalControllers.jumpTo((column - customWidthCells) * widget.tableDimensions.cellWidth + customWidth);

    double customHeight = 0;
    int customHeightCells = 0;
    for (int i = 0; i < column; i++) {
      if (widget.tableDimensions.customCellHeight.containsKey(i)) {
        customHeight += widget.tableDimensions.customCellHeight[i];
        customHeightCells++;
      }
    }
    _verticalControllers.jumpTo((row - customHeightCells) * widget.tableDimensions.cellHeight + customHeight);
  }

  void jumpTo(double x, double y) {
    _horizontalControllers.jumpTo(x);
    _verticalControllers.jumpTo(y);
  }

  void jump(double x, double y) {
    _horizontalControllers.jump(x);
    _verticalControllers.jump(y);
  }
}

class _CustomScrollController extends ScrollController {
  _CustomScrollController(TickerProvider provider) : super() {
    _ticker = provider.createTicker((_) {
      jumpTo(offset + _velocity);
      _velocity *= 0.9;
      if (_velocity < 0.1 && _velocity > -0.1) {
        _ticker.stop();
      }
    });
  }

  List<ScrollPosition> _positions = [];

  double offset = 0;

  Ticker _ticker;

  double _velocity;

  @override
  void attach(ScrollPosition position) {
    position.correctPixels(offset);
    _positions.add(position);
  }

  @override
  void detach(ScrollPosition position) {
    _positions.remove(position);
  }

  void processNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      jumpTo(notification.metrics.pixels);
    }
  }

  @override
  void jumpTo(double value) {
    if (_positions[0] != null && value > _positions[0].maxScrollExtent) {
      offset = _positions[0].maxScrollExtent;
    } else if (value < 0) {
      offset = 0;
    } else {
      offset = value;
    }
    for (ScrollPosition position in _positions) {
      if (position.pixels != offset) {
        position.jumpTo(offset);
      }
    }
  }

  void jump(double value) {
    jumpTo(offset + value);
  }

  void setVelocity(double velocity) {
    if (_ticker.isActive) _ticker.stop();
    _velocity = velocity;
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
