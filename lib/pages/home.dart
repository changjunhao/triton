import 'dart:io';
import 'dart:async';
// import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String _company = '';
  String _create = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final counter = prefs.getStringList('counter');
    if (counter != null) {
      setState(() {
        _company = counter[0];
        _create = counter[1];
      });
    }
  }

  _handleLogout() {
    final returnTickets = <Future>[getApplicationDocumentsDirectory(), SharedPreferences.getInstance()];
    Future.wait(returnTickets).then((result) async {
      Directory appDocDir = result[0];
      String appDocPath = appDocDir.path;
      final cj = PersistCookieJar(ignoreExpires: true, storage: FileStorage("$appDocPath/.cookies/" ));
      cj.delete(Uri.parse('https://vip.meimiaoip.com'));
      SharedPreferences prefs = result[1];
      await prefs.clear();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  _showQR() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.5),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * (26 / 375)),
                width: MediaQuery.of(context).size.width * (180 / 375),
                height: MediaQuery.of(context).size.width * (200 / 375),
                color: const Color(0xffffffff),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onLongPress: _showDownQR,
                      child: const Image(image: AssetImage('assets/images/erweima.png')),
                    ),
                    Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * (16 / 375))),
                    Text(
                      '微信添加好友，了解详情',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * (12 / 375),
                          color: const Color(0xFF333333)
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * (20 / 375)),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Image(image: AssetImage('assets/images/close.png')),
                ),
              )
            ],
          );
        }
    );
  }

  _showDownQR() {
    showCupertinoModalPopup(context: context, builder: (context) {
      return CupertinoActionSheet(
        title: const Text('操作'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: _downloadImage,
            child: const Text('下载二维码'),
          )
        ],
      );
    });
  }

  _downloadImage() async {
    Navigator.pop(context);
    Map<Permission, PermissionStatus> statuses = await [Permission.photos].request();
    if (statuses[Permission.photos] == PermissionStatus.granted) {
      if (!mounted) return;
      final bytes = await DefaultAssetBundle.of(context).load('assets/images/3x/erweima.png');
      final result = await ImageGallerySaver.saveImage(bytes.buffer.asUint8List());
      if (!mounted) return;
      if (result['isSuccess']) {
        showCupertinoDialog(context: context, builder: (BuildContext context) {
          return const CupertinoAlertDialog(
            content: Text('下载完成，请到相册查看'),
          );
        });
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        showCupertinoDialog(context: context, builder: (BuildContext context){
          return const CupertinoAlertDialog(
            content: Text('下载失败'),
          );
        });
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      }
    } else {
      if (!mounted) return;
      showCupertinoDialog(context: context, builder: (BuildContext context){
        return const CupertinoAlertDialog(
          content: Text('请检查图库权限'),
        );
      });
      Timer(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 0.5),
        middle: Text(widget.title),
        trailing: CupertinoButton(
          padding: const EdgeInsets.symmetric(vertical: 0),
          pressedOpacity: 0.5,
          onPressed: _handleLogout,
          child: const Text("退出"),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                  minHeight: MediaQuery.of(context).size.width * 0.4207,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bg.png'),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * (343 / 375),
                      margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * (40 / 375),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _company,
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: MediaQuery.of(context).size.width * (17 / 375),
                                  ),
                                ),
                                Text(
                                  '$_create注册',
                                  style: TextStyle(
                                    color: CupertinoColors.white,
                                    fontSize: MediaQuery.of(context).size.width * (11 / 375),
                                  ),
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: _showQR,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * (90 / 375),
                              height: MediaQuery.of(context).size.width * (35 / 375),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFE0B66D),
                                  width: 1.0,
                                ),
                              ),
                              child: Text(
                                '充值',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * (15 / 375),
                                  color: const Color(0xFFE0B66D),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ListBody(
                      children: <Widget>[
                        VoucherWidget(
                          amount: 500,
                          quota: 5000,
                          amountColor: Color.fromRGBO(102, 102, 102, 1),
                          buttonColor: Color.fromRGBO(153, 153, 153, 1),
                          buttonFontColor: Color.fromRGBO(255, 255, 255, 1),
                          textColor: [
                            Color.fromRGBO(51, 51, 51, 1),
                            Color.fromRGBO(102, 102, 102, 1),
                            Color.fromRGBO(102, 102, 102, 1)
                          ],
                        ),
                        VoucherWidget(
                          amount: 600,
                          quota: 10000,
                          amountColor: Color.fromRGBO(204, 204, 204, 1),
                          buttonColor: Color.fromRGBO(153, 153, 153, 1),
                          buttonFontColor: Color.fromRGBO(255, 255, 255, 1),
                          textColor: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(204, 204, 204, 1),
                            Color.fromRGBO(204, 204, 204, 1)
                          ],
                        ),
                        VoucherWidget(
                          amount: 600,
                          quota: 10000,
                          amountColor: Color.fromRGBO(204, 204, 204, 1),
                          buttonColor: Color.fromRGBO(153, 153, 153, 1),
                          buttonFontColor: Color.fromRGBO(255, 255, 255, 1),
                          textColor: [
                            Color.fromRGBO(255, 255, 255, 1),
                            Color.fromRGBO(204, 204, 204, 1),
                            Color.fromRGBO(204, 204, 204, 1)
                          ],
                        ),
                        VoucherWidget(
                          amount: 2000,
                          quota: 30000,
                          amountColor: Color.fromRGBO(224, 182, 109, 1),
                          buttonColor: Color.fromRGBO(100, 100, 100, 1),
                          buttonFontColor: Color.fromRGBO(255, 255, 255, 1),
                          textColor: [
                            Color.fromRGBO(224, 182, 109, 1),
                            Color.fromRGBO(224, 182, 109, 1),
                            Color.fromRGBO(224, 182, 109, 1)
                          ],
                        ),
                        VoucherWidget(
                          amount: 2000,
                          quota: 30000,
                          amountColor: Color.fromRGBO(224, 182, 109, 1),
                          buttonColor: Color.fromRGBO(100, 100, 100, 1),
                          buttonFontColor: Color.fromRGBO(255, 255, 255, 1),
                          textColor: [
                            Color.fromRGBO(224, 182, 109, 1),
                            Color.fromRGBO(224, 182, 109, 1),
                            Color.fromRGBO(224, 182, 109, 1)
                          ],
                        ),
                        VoucherWidget(
                          amount: 4500,
                          quota: 60000,
                          amountColor: Color.fromRGBO(51, 51, 51, 1),
                          buttonColor: Color(0xFFFFE5B7),
                          buttonFontColor: Color.fromRGBO(102, 102, 102, 1),
                          textColor: [
                            Color.fromRGBO(51, 51, 51, 1),
                            Color.fromRGBO(102, 102, 102, 1),
                            Color.fromRGBO(102, 102, 102, 1)
                          ],
                        ),
                      ],
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

class VoucherWidget extends StatelessWidget {
  const VoucherWidget({
    super.key,
    required this.amount,
    required this.quota,
    required this.amountColor,
    required this.buttonColor,
    required this.buttonFontColor,
    required this.textColor,
  });
  final int amount;
  final int quota;
  final Color amountColor;
  final Color buttonColor;
  final Color buttonFontColor;
  final List<Color> textColor;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width * (343 / 375),
      height: MediaQuery.of(context).size.width * (169 / 375),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * (25 / 375),
        left: MediaQuery.of(context).size.width * (28 / 375),
        right: MediaQuery.of(context).size.width * (30 / 375),
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/${amount}bg.png'),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '￥$amount',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (30 / 375),
                      color: amountColor,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (100 / 375),
                height: MediaQuery.of(context).size.width * (35 / 375),
                child: CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  onPressed: () => {},
                  pressedOpacity: 1,
                  color: buttonColor,
                  child: Text(
                    '已领取',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * (15 / 375),
                      color: buttonFontColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * (25 / 375))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('单笔订单满$quota可使用',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (13 / 375),
                  color: textColor[0],
                ),),
              Text('此代金券暂不支持对接类服务使用',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (11 / 375),
                  color: textColor[1],
                ),),
              Text('有效期至：2019年3月15日',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * (11 / 375),
                  color: textColor[2],
                ),)
            ],
          )
        ],
      ),
    );
  }
}