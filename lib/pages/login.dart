import 'dart:async';
//import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;
  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {

  String _phone = '';
  String _password = '';

  void _handlePhone(String text) {
    setState((){
      _phone = text;
    });
  }

  void _handlePassword(String text) {
    setState((){
      _password = text;
    });
  }

  Future _handleSubmitted() async {
    Response response = await dio.post(
        '/index.php/index/login/LoginWithPassword',
        data:{'phone': _phone, 'password': _password});
    if (response.data['errno'] == 0) {
      Response info = await dio.get('/index.php/index/user/UserInfo');
      if(info.data['data']['status'] == 1) {
        final dataTime = DateTime.fromMillisecondsSinceEpoch(info.data['data']['create_time'] * 1000);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('counter', <String>[
          info.data['data']['company'],
          '${dataTime.year}-${dataTime.month}-${dataTime.day}'
        ]);
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/info');
      }
    }
    if (response.data['errno'] != 0) {
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
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 36),
          alignment: Alignment.center,
          child: Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 88),
                  child: Image.asset('assets/images/logo.png'),
                ),
                new Container(
                    margin: const EdgeInsets.only(top: 9.0),
                    child: new Text(
                      '美秒新营销',
                      style: TextStyle(
                          color: Color.fromRGBO(224, 182, 109, 1.0),
                          fontSize: 18
                      ),
                    )
                ),
                new Text(
                  '短视频营销一站式服务平台',
                  style: TextStyle(
                      color: Color.fromRGBO(224, 182, 109, 1.0),
                      fontSize: 12
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(top: 36.0),
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
                    placeholder: '请输入密码',
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
                  alignment: Alignment.centerRight,
                  child: new CupertinoButton(
                    pressedOpacity: 0.5,
                    onPressed: () => Navigator.of(context).pushNamed('/register'),
                    child: Text(
                      '注册',
                      style: TextStyle(
                        color: Color.fromRGBO(51, 51, 51, 1),
                        fontSize: 14
                      ),
                    ),
                  ),
                ),
                new Container(
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new CupertinoButton(
                          color: Color.fromRGBO(224, 182, 109, 1),
                          pressedOpacity: 0.5,
                          onPressed: _handleSubmitted,
                          child: Text("登录"),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
          ),
        ),
      ),
    );
  }
}