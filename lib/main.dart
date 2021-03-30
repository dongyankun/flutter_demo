import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart' hide Action, Page;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterdemo/home_page/page.dart';
import 'package:flutterdemo/index_page/page.dart';
import 'package:flutterdemo/user_store/state.dart';
import 'package:flutterdemo/user_store/store.dart';
import 'dart:math' as math;

void main() => runApp(createApp());
Widget createApp() {
  initState();
  final AbstractRoutes routes = PageRoutes(
    pages: <String, Page<Object, dynamic>>{
      /// 注册TodoList主页面
      'home': HomePage(),
      "index": IndexPage()
    },
    visitor: (String path, Page<Object, dynamic> page) {
      /// 只有特定的范围的 Page 才需要建立和 AppStore 的连接关系
      /// 满足 Page<T> ，T 是 GlobalBaseState 的子类
      if (page.isTypeof<UserBaseState>()) {
        /// 建立 AppStore 驱动 PageStore 的单向数据连接
        /// 1. 参数1 AppStore
        /// 2. 参数2 当 AppStore.state 变化时, PageStore.state 该如何变化
        page.connectExtraStore<UserBaseState>(UserStore.store,
            (Object pagestate, UserBaseState appState) {
          final UserBaseState p = pagestate;
          if (p.name != appState.name) {
            if (pagestate is Cloneable) {
              final Object copy = pagestate.clone();
              final UserBaseState newState = copy;
              newState.name = appState.name;
              return newState;
            }
          }
          return pagestate;
        });
      }

      /// AOP
      /// 页面可以有一些私有的 AOP 的增强， 但往往会有一些 AOP 是整个应用下，所有页面都会有的。
      /// 这些公共的通用 AOP ，通过遍历路由页面的形式统一加入。
      //   page.enhancer.append(
      //     /// View AOP
      //     viewMiddleware: <ViewMiddleware<dynamic>>[
      //       safetyView<dynamic>(),
      //     ],

      //     /// Adapter AOP
      //     adapterMiddleware: <AdapterMiddleware<dynamic>>[
      //       safetyAdapter<dynamic>()
      //     ],

      //     /// Effect AOP
      //     effectMiddleware: <EffectMiddleware<dynamic>>[
      //       _pageAnalyticsMiddleware<dynamic>(),
      //     ],

      //     /// Store AOP
      //     middleware: <Middleware<dynamic>>[
      //       logMiddleware<dynamic>(tag: page.runtimeType.toString()),
      //     ],
      //   );
    },
  );

  return MaterialApp(
    title: 'Fluro',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: routes.buildPage('home', null),
    onGenerateRoute: (RouteSettings settings) {
      return MaterialPageRoute<Object>(builder: (BuildContext context) {
        ScreenUtil.init(context, width: 750, height: 1334);
        return routes.buildPage(settings.name, settings.arguments);
      });
    },
  );
}

/// 简单的 Effect AOP
/// 只针对页面的生命周期进行打印
// EffectMiddleware<T> _pageAnalyticsMiddleware<T>({String tag = 'redux'}) {
//   return (AbstractLogic<dynamic> logic, Store<T> store) {
//     return (Effect<dynamic> effect) {
//       return (Action action, Context<dynamic> ctx) {
//         if (logic is Page<dynamic, dynamic> && action.type is Lifecycle) {
//           print('${logic.runtimeType} ${action.type.toString()} ');
//         }
//         return effect?.call(action, ctx);
//       };
//     };
//   };
// }
@override
void initState() {
  //super.initState();
  // 这里初始化腾讯信鸽服务
  void main() {
    int num = 111;
    int data = math.max(1, 1);
    println(data);
  }

  main();
}
