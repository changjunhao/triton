import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages/login.dart';
import 'pages/info.dart';
import 'pages/register.dart';
import 'pages/home.dart';
import 'utils/request.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String appDocPath = appDocDir.path;
  var cj = PersistCookieJar(ignoreExpires: true, storage: FileStorage("$appDocPath/.cookies/" ));

  dio.interceptors..add(CookieManager(cj))..add(LogInterceptor());

  Future<bool> getLoginStatus() async {
    List<Cookie> results = await cj.loadForRequest(Uri.parse('https://vip.meimiaoip.com'));
    try {
      Cookie usersign = results.firstWhere((Cookie cookie) => cookie.toString().contains('usersign'));
      if (SerializableCookie(usersign).isExpired()) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  Future<bool> getInfoStatus() async {
    Response response = await dio.get('/index.php/index/user/UserInfo');
    if(response.data['data']['status'] == 0) {
      return false;
    } else{
      final int time = int.parse(response.data['data']['create_time']);
      final dataTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('counter', <String>[
        response.data['data']['company'],
        '${dataTime.year}-${dataTime.month}-${dataTime.day}'
      ]);
      return true;
    }
  }

  final loginStatus = await getLoginStatus();
  if (!loginStatus) {
    return runApp(TritonApp(loginStatus, false));
  }
  final infoStatus = await getInfoStatus();
  return runApp(TritonApp(loginStatus, infoStatus));
}

class TritonApp extends StatelessWidget {
  const TritonApp(this.loginStatus, this.infoStatus, {super.key});
  final bool loginStatus;
  final bool infoStatus;
  final String title = '美秒新营销';

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> routes = {
      '/home': (BuildContext context) => HomePage(title: title, key: const Key("Home"),),
      '/login': (BuildContext context) => const Login(title: '登录', key: Key("Login"),),
      '/info': (BuildContext context) => const InfoPage(title: '企业信息', key: Key("Info"),),
      '/register': (BuildContext context) => const RegisterPage(title: '注册', key: Key("Register"),),
    };
    final Widget home = loginStatus
        ? infoStatus ? HomePage(title: title, key: const Key("Home"),) : const InfoPage(title: '企业信息', key: Key("Info"),)
        : const Login(title: '登录', key: Key("Login"),);

    if (Platform.isIOS) {
      return CupertinoApp(
        title: title,
        routes: routes,
        home: home,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh'), // English
        ],
      );
    }
    return MaterialApp(
      title: title,
      theme: ThemeData.light(),
      routes: routes,
      home: home,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh'), // English
      ],
    );
  }
}
