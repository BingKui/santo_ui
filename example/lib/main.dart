import 'package:santo_ui/santo_ui.dart';
import 'sample/l10n/l10n.dart';
import 'package:example/sample/components/layout/app_layout_example.dart';
import 'package:example/sample/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  SantoIntl.add(ResourceDe.locale, ResourceDe());
  // 全局导航栏使用浅色背景
  SantoThemeConfigurator.instance.register(
    SantoAllThemeConfig(appBarConfig: SantoAppBarConfig.light()),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ChangeLocalEvent>(
      onNotification: (_) {
        setState(() {});
        return true;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: ChangeLocalEvent.locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          SantoLocalizationDelegate.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('zh', 'CN'),
          Locale('de', 'DE'),
        ],
        title: 'Flutter Example',
        // AppLayout 示例「更多」菜单的页面地址
        routes: {
          AppLayoutDemoRoutes.notice: (_) =>
              const AppLayoutDemoRoutePage(title: '通知'),
          AppLayoutDemoRoutes.schedule: (_) =>
              const AppLayoutDemoRoutePage(title: '日程'),
          AppLayoutDemoRoutes.report: (_) =>
              const AppLayoutDemoRoutePage(title: '报表'),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        ),
        home: HomePage(),
      ),
    );
  }
}
