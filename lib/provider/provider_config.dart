import 'package:kqsc/model/user_model.dart';
import 'package:kqsc/provider/chat_provider.dart';
import 'package:kqsc/provider/shoping_pro.dart';
import 'package:kqsc/provider/user_provider.dart';
import 'package:paixs_utils/util/utils.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'app_provider.dart';

///Porviders集
List<SingleChildWidget> pros = <SingleChildWidget>[
  ChangeNotifierProvider.value(value: UserProvider()),
  ChangeNotifierProvider.value(value: AppProvider()),
  ChangeNotifierProvider.value(value: ChatProvider()),
  ChangeNotifierProvider.value(value: ShopingPro()),
];

UserProvider get userPro => Provider.of<UserProvider>(context, listen: false);

///用户信息
UserModel get user => userPro.userModel;

AppProvider get app => Provider.of<AppProvider>(context, listen: false);

ChatProvider get chat => Provider.of<ChatProvider>(context, listen: false);

ShopingPro get shoping => Provider.of<ShopingPro>(context, listen: false);
