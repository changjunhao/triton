import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../utils/request.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {

  String _phone = '';
  String _password = '';
  String _passwordRepeat = '';
  String _code = '';
  int _seconds = 0;
  late Timer _timer;
  String _verifyStr = '获取验证码';

  void _handlePhone(String text) {
    setState((){
      _phone = text;
    });
  }

  void _handleCode(String text) {
    setState((){
      _code = text;
    });
  }

  void _handlePassword(String text) {
    setState((){
      _password = text;
    });
  }

  void _handlePasswordRepeat(String text) {
    setState((){
      _passwordRepeat = text;
    });
  }

  _cancelTimer() {
    _seconds = 0;
    _timer.cancel();
  }

  Future _handleRegister() async {
    if (kDebugMode) {
      print(_phone);
    }
    Response response = await dio.post(
        '/index.php/index/login/RegisterWithMessageCode',
        data: {
          'register_phone': _phone,
          'password': _password,
          'password_repeat': _passwordRepeat,
          'code': _code
        });
    if (response.data['errno'] == 0) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/info');
    }
    if (!mounted) return;
    if (response.data['errno'] == -3) {
      Future result = await showCupertinoDialog(context: context, builder: (BuildContext context){
        return CupertinoAlertDialog(
            content: const Text('已注册，请登录'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('登录'),
              )
            ]
        );
      });
      if (!mounted) return;
      Navigator.of(context).pop(result);
    }
    if (!mounted) return;
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return CupertinoAlertDialog(
        content: Text(response.data['errmsg']),
      );
    });
    Timer(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  Future _handleGetCode() async {
    _seconds = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      setState((){
        _verifyStr = '$_seconds(s)';
      });
      if (_seconds == 0) {
        setState((){
          _verifyStr = '获取验证码';
        });
      }
    });

    Response response = await dio.get(
        '/index.php/utility/message/sendMobileMessage',
        queryParameters: {'phone': _phone});
    if (response.data['errno'] != 0) {
      _cancelTimer();
      if (!mounted) return;
      showCupertinoDialog(context: context, builder: (BuildContext context){
        return CupertinoAlertDialog(
          content: Text(response.data['errmsg']),
        );
      });
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20),
          margin: const EdgeInsets.symmetric(horizontal: 36),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 44.0),
                height: 46,
                child: CupertinoTextField(
                  padding: const EdgeInsets.only(left: 15.0),
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  placeholder: '请输入手机号',
                  onChanged: _handlePhone,
                  style: const TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  prefix: Container(
                    height: 46,
                    width: 73,
                    color: const Color.fromRGBO(219, 219, 219, 1),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('+86',
                          style: TextStyle(
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: const BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: const EdgeInsets.only(left: 15.0),
                  keyboardType: TextInputType.number,
                  placeholder: '请输入验证码',
                  onChanged: _handleCode,
                  style: const TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  suffix: SizedBox(
                    height: 46,
                    width: 115,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            padding: const EdgeInsets.all(0),
                            borderRadius: null,
                            color: const Color.fromRGBO(224, 182, 109, 1),
                            pressedOpacity: 0.5,
                            onPressed: _seconds == 0 ? _handleGetCode : null,
                            child: Text(_verifyStr, style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: const BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: const EdgeInsets.only(left: 15.0),
                  placeholder: '设置密码',
                  obscureText: true,
                  onChanged: _handlePassword,
                  style: const TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  decoration: const BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: const EdgeInsets.only(left: 15.0),
                  placeholder: '确认密码',
                  obscureText: true,
                  onChanged: _handlePasswordRepeat,
                  style: const TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  decoration: const BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoButton(
                        color: const Color.fromRGBO(224, 182, 109, 1),
                        pressedOpacity: 0.5,
                        onPressed: _handleRegister,
                        child: const Text("完成"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}