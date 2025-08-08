# Flutter APP

## 技术架构

### 核心技术栈
- Flutter 3.24.5
- Dart
- Provider 状态管理
- Dio 网络请求库

### 主要第三方库
- flutter_styled_toast: 消息提示
- pull_to_refresh: 下拉刷新和上拉加载
- cached_network_image: 网络图片缓存
- image_picker: 图片选择
- shared_preferences: 本地数据存储
- flutter_svg: SVG 图片支持
- url_launcher: URL 跳转
- permission_handler: 权限管理
- photo_view: 图片查看器

### 项目结构
```
lib/
├── config/           # 配置文件
├── model/            # 数据模型
├── page/             # 页面组件
├── provider/         # 状态管理
├── util/             # 工具类
├── view/             # 视图组件
├── widget/           # 自定义组件
├── main.dart         # 应用入口
package/
└── paixs_utils/     # 自定义工具包
```

## 快速开始

### 环境要求
- Flutter 3.24.5
- Dart 2.19.6 或更高版本
- Android Studio / VS Code

### 安装步骤
1. 克隆项目代码
2. 进入项目目录
3. 执行以下命令安装依赖：

```bash
flutter clean
flutter pub get
```

### 运行项目
```bash
# 运行在连接的设备或模拟器上
flutter run

# 构建 APK
flutter build apk

# 构建 iOS 应用（需要 macOS 环境）
flutter build ios
```

## 功能模块详解

### 页面组件 (lib/page/)
- `home/`: 首页相关页面
- `wode/`: 个人中心相关页面，包括设置、反馈等

### 自定义工具包 (package/paixs_utils/)
项目包含一个自定义的工具包 paixs_utils，提供了丰富的组件和工具：

1. 数据模型
   - DataModel: 统一的数据处理模型，支持分页、错误处理和状态管理

2. UI 组件库
   - ScaffoldWidget: 增强版页面脚手架
   - MyListView: 功能丰富的列表组件，支持下拉刷新和上拉加载
   - MyText: 增强文本组件
   - 动画组件：AnimaSwitchWidget、TweenWidget 等

3. 工具函数
   - 网络请求工具
   - 常用工具函数集合

## 开发规范

### 代码规范
- 遵循 Flutter 官方代码规范
- 使用 Provider 进行状态管理
- 组件化开发，提高代码复用性

### 命名规范
- 文件名：小写加下划线，如 `home_page.dart`
- 类名：大驼峰命名，如 `HomePage`
- 方法名：小驼峰命名，如 `getUserInfo()`

## 常见问题

### 构建问题
如果遇到构建问题，请尝试以下步骤：
1. 执行 `flutter clean`
2. 删除 `pubspec.lock` 文件
3. 重新执行 `flutter pub get`

### 依赖问题
如果遇到依赖问题，请检查：
1. Flutter 版本是否匹配（3.24.5）
2. 依赖库版本是否兼容

## 贡献

欢迎提交 Issue 和 Pull Request 来帮助改进项目。

## 许可证

[MIT License](LICENSE)