import 'package:MOYU/check_app_version.dart';
import 'package:MOYU/componts/update_dialog.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/data/like_data_center.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/model/home_page_featured_model.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key) {}

  //bool state;
  //final selectWidget;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _ifacceptAgreement = false;
  bool canLogin = false, isInputValid = false, _ifhide = true;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var token;
  @override
  void initState() {
    super.initState();
    canLogin = false;
    _ifhide = true;
    _ifacceptAgreement = false;
    //_checkupdate();
    _upgrade();
  }

  _upgrade() async {
    var tmp = await CheckUpdate();
    if (tmp != false) {
      Future.delayed(Duration(milliseconds: 30), (() {
        UpdateDialog(context);
      }));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  //void dispose() => super.dispose();

  void _checkInputValid(String _) {
    isInputValid =
        (_accountController.text != null) && (_passwordController.text != null);
    return;
    //if (isInputValid == canLogin) {
    //  return;
    //}
    //setState(() => canLogin = isInputValid);
  }

  Future _login() async {
    if (!isInputValid) return;
    //if (await checkConnectivityResult(context) == false) return;
    //print('before canLogin:$canLogin');
    try {
      // 登录成功
      LCUser user =
          await LCUser.login(_accountController.text, _passwordController.text);
      //LCUser? currentUser = await LCUser.getCurrent();
      //print('user:$user');

      if (user['nickname'] == null) {
        canLogin = false;
        //print('false');
        return;
      }
      await Provider.of<TokenUtil>(context, listen: false).saveLoginInfo(user);
      //await TokenUtil().saveLoginInfo(user);

      canLogin = true;
      //AddDataCenter().initData();
      //OnSellDataCenter().initData();

      //rint('after try canLogin:$canLogin');
    } on LCException catch (e) {
      // 登录失败（可能是密码错误）
      //print('${e.code} : ${e.message}');
      canLogin = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:{e.code} : ${e.message}')));

      // print('false');
      //return '${e.code} : ${e.message}';
    }
    //if (kDebugMode) {
    //  print('after canLogin:$canLogin');
    //}

    return;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        //extendBody: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                //maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.all(20.0),
                        padding:
                            const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 15.0),
                        //child: Image(image: AssetImage("images/1.png", ),),
                        //child: Image.network(
                        //'login_page_image.gif',
                        //'http://www.fzyz.net/fzyz_file/file/ueditor/2020/12/30/1609299111648.gif',
                        //fit: BoxFit.fitWidth,
                        //),
                        child: Image.asset(
                          //'login_page_image.gif',
                          'images/Online_education_PNG.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      'M O Y U',
                      style: TextStyleDefault.IndividualText,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: "用户名",
                            hintText: "请输入您的学号",
                            focusColor: Colors.black,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            //focusedBorder: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.black),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            )),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (String value) {
                          FocusScope.of(context).nextFocus();
                        },
                        controller: _accountController,
                        onChanged: _checkInputValid,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(25.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _ifhide,
                        onChanged: _checkInputValid,
                        decoration: InputDecoration(
                          labelText: "密码",
                          hintText: "请输入您的密码",
                          labelStyle: TextStyle(color: Colors.black),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Colors.black,
                          ),
                          suffix: IconButton(
                            icon: _ifhide == true
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _ifhide = !_ifhide;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            //checkColor: Colors.black,
                            activeColor: Colors.black,
                            value: _ifacceptAgreement,
                            onChanged: (bool) {
                              setState(() {
                                _ifacceptAgreement = !_ifacceptAgreement;
                              });
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('已阅读并同意',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal)),
                            TextButton(
                                onPressed: () {
                                  RouterUtil.toPrivacyPolicyPage(context);
                                },
                                child: Text(
                                  '《隐私政策》',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal),
                                )),
                            Text('和',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal)),
                            TextButton(
                                onPressed: () {
                                  RouterUtil.toUserAgreementPage(context);
                                },
                                child: Text(
                                  '《用户协议》',
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.normal),
                                )),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    SizedBox(
                      //padding: const EdgeInsets.all(30.0),
                      height: 50.0,
                      width: 200.0,
                      child: ElevatedButton(
                        onPressed: () async {
                          //isInputValid ? await _login : null;
                          if (_ifacceptAgreement == false) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text('请先阅读并同意《隐私政策》和《用户协议》'),
                                    ));
                          } else {
                            if (isInputValid) await _login();
                            if (canLogin == true) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('登录'),
                                        content: Text('恭喜你，登陆成功！'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () {
                                                var user = context
                                                    .read<TokenUtil>()
                                                    .localuser;
                                                if (user['class'] != null) {
                                                  Provider.of<HomePageFeaturedModel>(
                                                          context,
                                                          listen: false)
                                                      .initData();
                                                  Provider.of<LikeDataCenter>(
                                                          context,
                                                          listen: false)
                                                      .initData(context);
                                                  RouterUtil.toIndexPage(
                                                      context);
                                                } else {
                                                  RouterUtil
                                                      .toUserInitializationPage(
                                                          context);
                                                }
                                              },
                                              child: Text('继续'))
                                        ],
                                      ));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('登录失败'),
                                        content: Text('该用户不存在或密码错误'),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () =>
                                                  RouterUtil.pop(context),
                                              child: Text('关闭'))
                                        ],
                                      ));
                            }
                          }
                        },
                        child: const Text('登录'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Row(
                        children: <Widget>[
                          const Text('没有账号？'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                );
                              },
                              child: const Text('立即注册')),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
