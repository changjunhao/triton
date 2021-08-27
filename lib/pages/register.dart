import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import '../utils/request.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

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
    print(_phone);
    Response response = await dio.post(
        '/index.php/index/login/RegisterWithMessageCode',
        data: {
          'register_phone': _phone,
          'password': _password,
          'password_repeat': _passwordRepeat,
          'code': _code
        });
    if (response.data['errno'] == 0) {
      Navigator.of(context).pushReplacementNamed('/info');
    }
    if (response.data['errno'] == -3) {
      Future result = await showCupertinoDialog(context: context, builder: (BuildContext context){
        return new CupertinoAlertDialog(
            content: Text('已注册，请登录'),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('登录'),
              )
            ]
        );
      });
      Navigator.of(context).pop(result);
    }
    showCupertinoDialog(context: context, builder: (BuildContext context){
      return new CupertinoAlertDialog(
        content: Text(response.data['errmsg']),
      );
    });
    new Timer(new Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  Future _handleGetCode() async {
    _seconds = 60;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
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
      showCupertinoDialog(context: context, builder: (BuildContext context){
        return new CupertinoAlertDialog(
          content: Text(response.data['errmsg']),
        );
      });
      new Timer(new Duration(seconds: 2), () {
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
          margin: EdgeInsets.symmetric(horizontal: 36),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(top: 44.0),
                height: 46,
                child: CupertinoTextField(
                  padding: EdgeInsets.only(left: 15.0),
                  keyboardType: TextInputType.phone,
                  maxLength: 11,
                  placeholder: '请输入手机号',
                  onChanged: _handlePhone,
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  prefix: Container(
                    height: 46,
                    width: 73,
                    color: Color.fromRGBO(219, 219, 219, 1),
                    child: Row(
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
                  decoration: BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: EdgeInsets.only(left: 15.0),
                  keyboardType: TextInputType.number,
                  placeholder: '请输入验证码',
                  onChanged: _handleCode,
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  suffix: Container(
                    height: 46,
                    width: 115,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new CupertinoButton(
                            padding: EdgeInsets.all(0),
                            borderRadius: null,
                            color: Color.fromRGBO(224, 182, 109, 1),
                            pressedOpacity: 0.5,
                            onPressed: _seconds == 0 ? _handleGetCode : null,
                            child: Text(_verifyStr, style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: EdgeInsets.only(left: 15.0),
                  placeholder: '设置密码',
                  obscureText: true,
                  onChanged: _handlePassword,
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  decoration: BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 20.0),
                height: 46,
                child: CupertinoTextField(
                  padding: EdgeInsets.only(left: 15.0),
                  placeholder: '确认密码',
                  obscureText: true,
                  onChanged: _handlePasswordRepeat,
                  style: TextStyle(
                    color: Color.fromRGBO(51, 51, 51, 1),
                    fontSize: 15,
                  ),
                  decoration: BoxDecoration(
                      border: null,
                      color: Color.fromRGBO(242, 242, 242, 1)
                  ),
                ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 30.0),
                alignment: Alignment.center,
                child: new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new CupertinoButton(
                        color: Color.fromRGBO(224, 182, 109, 1),
                        pressedOpacity: 0.5,
                        onPressed: _handleRegister,
                        child: Text("完成"),
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