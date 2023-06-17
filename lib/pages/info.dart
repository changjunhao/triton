import 'dart:async';
import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/request.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {

  String _company = '';
  String _name = '';
  String _phone = '';
  String _email = '';
  String _wechat = '';
  String _code = '';

  FocusNode companyFocusNode = FocusNode();

  final GlobalKey<FormState> _infoFormKey = GlobalKey();

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
    if (kDebugMode) {
      print(response);
    }
    if (!mounted) return;
    if (response.data['errno'] != 0) {
      showCupertinoDialog(context: context, builder: (BuildContext context){
        return CupertinoAlertDialog(
          content: Text(response.data['errmsg']),
        );
      });
      Timer(const Duration(seconds: 2), () {
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
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5),
      ),
      child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _infoFormKey,
                child: Column(
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                          '企业名称',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(51, 51, 51, 1),
                            fontWeight: FontWeight.bold
                          )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        placeholder: '请输入真实的企业名称',
                        onChanged: (value) {
                          setState(() {
                            _company = value;
                          });
                        },
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
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                            '联系人',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        placeholder: '请输入联系人姓名',
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
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
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                            '联系电话',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.phone,
                        placeholder: '请输入真实的联系电话',
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
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
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                            '邮箱',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.emailAddress,
                        placeholder: '请输入邮箱',
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
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
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                            '微信',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        placeholder: '请输入微信号',
                        onChanged: (value) {
                          setState(() {
                            _wechat = value;
                          });
                        },
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
                    const Row(
                      children: <Widget>[
                        Icon(
                          IconData(0xe885, fontFamily: 'MaterialIcons'),
                          color: Color.fromRGBO(255, 79, 79, 1),
                          size: 8,
                        ),
                        Padding(padding: EdgeInsets.only(left: 4)),
                        Text(
                            '邀请码',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(51, 51, 51, 1),
                                fontWeight: FontWeight.bold
                            )
                        )
                      ],
                    ),
                    Container(
                      height: 46,
                      margin: const EdgeInsets.only(top: 10, bottom: 15),
                      child: CupertinoTextField(
                        padding: const EdgeInsets.only(left: 15.0),
                        keyboardType: TextInputType.number,
                        placeholder: '请输入邀请码',
                        onChanged: (value) {
                          setState(() {
                            _code = value;
                          });
                        },
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
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CupertinoButton(
                              color: const Color.fromRGBO(224, 182, 109, 1),
                              pressedOpacity: 0.5,
                              onPressed: _handleAddUserInfo,
                              child: const Text("完成"),
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