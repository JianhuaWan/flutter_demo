# paixs_utils

一个功能丰富的Flutter工具包，提供了一系列常用的组件、模型和工具函数，用于加速Flutter应用开发。

## 功能概述

paixs_utils是一个综合性的Flutter工具包，包含以下主要功能模块：

### 1. 网络请求和数据模型
- [DataModel](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/model/data_model.dart#L5-L70)：统一的数据处理模型，支持分页、错误处理和状态管理
- 网络请求配置和API管理

### 2. UI组件库
- [ScaffoldWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/scaffold_widget.dart#L11-L103)：增强版页面脚手架，支持更多自定义选项
- [MyListView](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/mylistview.dart#L13-L177)：功能丰富的列表组件，支持下拉刷新和上拉加载
- [MyText](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/mytext.dart#L8-L75)：增强文本组件，支持更多样式配置
- 动画组件：[AnimaSwitchWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/anima_switch_widget.dart#L12-L105)、[TweenWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/tween_widget.dart#L11-L63)等
- 路由和页面跳转相关组件

### 3. 工具函数
- 常用工具函数集合
- 接口定义和管理

### 4. 集成的第三方库
- dio：网络请求
- pull_to_refresh：下拉刷新功能
- cached_network_image：网络图片缓存
- image_picker：图片选择器
- shared_preferences：本地数据存储
- flutter_svg：SVG图片支持
- url_launcher：URL跳转
- shimmer：骨架屏加载效果
- photo_view：图片查看器
- loading_indicator：加载指示器
- waterfall_flow：瀑布流布局

## 安装

在`pubspec.yaml`中添加依赖：

```yaml
dependencies:
  paixs_utils:
    path: package/paixs_utils
```

## 使用示例

```dart
import 'package:paixs_utils/model/data_model.dart';
import 'package:paixs_utils/widget/scaffold_widget.dart';
import 'package:paixs_utils/widget/mylistview.dart';
import 'package:paixs_utils/widget/mytext.dart';

class ExamplePage extends StatelessWidget {
  final dataModel = DataModel<String>();
  
  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: buildTitle(context, title: '示例页面'),
      body: MyListView(
        item: (index) => MyText('列表项 $index'),
        itemCount: 10,
      ),
    );
  }
}
```

## 功能模块详解

### 数据模型 (DataModel)
用于统一管理页面数据状态，支持：
- 数据加载状态管理（初始化、加载中、空数据、错误等）
- 分页数据处理
- 列表数据和单对象数据处理

### UI组件
提供一系列预封装的UI组件，包括：
- 页面脚手架：[ScaffoldWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/scaffold_widget.dart#L11-L103)
- 列表组件：[MyListView](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/mylistview.dart#L13-L177)
- 文本组件：[MyText](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/mytext.dart#L8-L75)
- 图片组件：[Image](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/image.dart#L10-L71)
- 动画组件：[AnimaSwitchWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/anima_switch_widget.dart#L12-L105)、[TweenWidget](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/tween_widget.dart#L11-L63)
- 路由组件：[Route](file:///D:/Program%20Files%20(x86)/flutter-demo/package/paixs_utils/lib/widget/route.dart#L1-L724)

### 工具函数
提供常用的工具函数，包括但不限于：
- 日志打印
- 时间处理
- 字符串处理
- 数值转换

## 许可证

MIT