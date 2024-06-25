import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_video_community/modules/main/mine/widgets/pay/pay_controller.dart';
import 'package:flutter_video_community/utils/opennstall_util.dart';
import 'package:flutter_video_community/utils/umeng_util.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

import 'dependencies.dart';
import 'global/global.dart';
import 'global/controller/global_controller.dart';
import 'router/router.dart';
import 'themes/theme.dart';
import 'utils/cache.dart';
import 'utils/device.dart';
import 'utils/storage/index.dart';

void main() async {
  MediaKit.ensureInitialized();
  if (!DeviceUtil.isWeb) {
    UmengApmSdk(
      name: 'video_app',
      bver: '1.0.0+1',
      enableLog: true,
      errorFilter: {
        "mode": "ignore",
        "rules": [],
      },
    ).init(appRunner: (observer) async {
      return init();
    });
    runApp(
      Container(),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await init();
    runApp(
      MultiRepositoryProvider(
        providers: buildRepositories(),
        child: const MyApp(),
      ),
    );
  }
}

Future<Widget> init() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  if (!kIsWeb && DeviceUtil.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  await Global.init();
  await Storage.instance.init();
  await Cache.init();
  UmengUtil.init();

  Get.put<GlobalController>(
    GlobalController(),
  );
  Get.put<PayController>(
    PayController(),
  );

  if (!DeviceUtil.isWeb) {
    return MultiRepositoryProvider(
      providers: buildRepositories(),
      child: const MyApp(),
    );
  }

  return Container();
}

class MyApmWidgetsFlutterBinding extends ApmWidgetsFlutterBinding {
  @override
  void handleAppLifecycleStateChanged(AppLifecycleState state) {
    // 添加自己的实现逻辑
    print('AppLifecycleState changed to $state');
    super.handleAppLifecycleStateChanged(state);
  }

  static WidgetsBinding? ensureInitialized() {
    MyApmWidgetsFlutterBinding();
    return WidgetsBinding.instance;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (mounted && !DeviceUtil.isWeb) {
      OpenInstallTool.initPlatformState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      useInheritedMediaQuery: true,
      builder: (_, Widget? child) {
        return OKToast(
          backgroundColor: Colors.black.withOpacity(0.5),
          textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
          textPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          radius: 20,
          child: RefreshConfiguration(
            headerBuilder: () => const ClassicHeader(
              refreshingIcon: CupertinoActivityIndicator(),
            ),
            footerBuilder: () => const ClassicFooter(
              noDataText: '',
              loadingIcon: CupertinoActivityIndicator(),
            ),
            hideFooterWhenNotFull: true,
            child: GetMaterialApp(
              popGesture: true,
              debugShowCheckedModeBanner: false,
              title: 'video',
              theme: AppTheme.light(),
              darkTheme: AppTheme.light(),
              themeMode: AppTheme.mode,
              defaultTransition: Transition.rightToLeft,
              transitionDuration: const Duration(milliseconds: 200),
              initialRoute: AppRouter.splash,
              getPages: AppRouter.pages,
              navigatorObservers: <NavigatorObserver>[
                AppRouter.observer,
                AppRouter.routeObservers,
                FlutterSmartDialog.observer,
              ],
              builder: FlutterSmartDialog.init(),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('zh', 'CN'),
              ],
            ),
          ),
        );
      },
    );
  }
}
