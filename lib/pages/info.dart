import 'dart:async';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request.dart';

class InfoPage extends StatefulWidget {
  InfoPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  String _company = '';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _wechat = '';
  String _code = '';

  FocusNode companyFocusNode = new FocusNode();

  GlobalKey<FormState> _infoFormKey = new GlobalKey();

  Future _handleAddUserInfo() async {
    Response response = await dio.post(
        '/index.php/index/user/addUserInfo',
        data: {
          'company': _company,
          'contact_person': _name,
          'contact_phone': _phone,
          'email': _email,
          'wechat': _wechat,
          'invitation_code': _code,
        });
    print(response);
    if (response.data['errno'] != 0) {
      showCupertinoDialog(context: context, builder: (BuildContext context){
        return new CupertinoAlertDialog(
          content: Text(response.data['errmsg']),
        );
      });
      new Timer(new Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      int time = int.parse(response.data['data']['create_time']);
      final dataTime = DateTime.fromMillisecondsSinceEpoch(time * 1000);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('counter', <String>[
        response.data['data']['company'],
        '${dataTime.year}-${dataTime.month}-${dataTime.day}'
      ]);
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.5),
      ),
      child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16), 
            child: new Form(
                key: _infoFormKey,
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                          '企业名称',
                          style: new TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontWeight: FontWeight.bold
                          )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        placeholder: '请输入真实的企业名称',
                        onChanged: (value) {
                          setState(() {
                            _company = value;
                          });
                        },
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
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                            '联系人',
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        placeholder: '请输入联系人姓名',
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
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
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                            '联系电话',
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.phone,
                        placeholder: '请输入真实的联系电话',
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
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
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                            '邮箱',
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.emailAddress,
                        placeholder: '请输入邮箱',
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
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
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                            '微信',
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        placeholder: '请输入微信号',
                        onChanged: (value) {
                          setState(() {
                            _wechat = value;
                          });
                        },
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
                    new Row(
                      children: <Widget>[
                        new Icon(
                          const IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        new Text(
                            '邀请码',
                            style: new TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    new Container(
                      height: 46,
                      margin: EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.number,
                        placeholder: '请输入邀请码',
                        onChanged: (value) {
                          setState(() {
                            _code = value;
                          });
                        },
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
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 15),
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new CupertinoButton(
                              color: Color.fromRGBO(224, 182, 109, 1),
                              pressedOpacity: 0.5,
                              onPressed: _handleAddUserInfo,
                              child: Text("完成"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          )
      ),
    );
  }
}