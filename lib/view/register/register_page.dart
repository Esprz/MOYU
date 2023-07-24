import 'package:MOYU/componts/loading_widget.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

import 'check_fzyzer_id.dart';
//import 'dart:html';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _ifacceptAgreement = false, _ifhide = true;

  bool canRegister = false;

  bool isInputValid = false;

  final TextEditingController _accountController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  void _checkInputValid(String _) {
    isInputValid =
            (_accountController.text != '') && (_passwordController.text != '')
        /*&&
        (_classController.text != null) &&
        (_gradeController.text != null) &&
        (_nameController.text != null)*/
        ;
  }

  RegisterApp(String name) async {
    LCUser user = LCUser();

    user.username = _accountController.text;
    user.password = _passwordController.text;

    //LCObject object = LCObject('TestObject');
    //object['words'] = 'wwwww';
    //await object.save();

    user["nickname"] = name;

    try {
      await user.signUp();
    } on LCException catch (e) {
      //print(exception.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      return;
    }
    canRegister = true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ifacceptAgreement = true;
    _ifhide = true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //throw UnimplementedError();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("注册"),
          ),
          body: SingleChildScrollView(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Container(
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: "学号",
                                  hintText: "请输入您的学号(即为您的默认账号)",
                                  counterText: "即为您的默认账号(用户名)",
                                  prefixIcon: Icon(Icons.numbers)),
                              textInputAction: TextInputAction.next,
                              onChanged: _checkInputValid,
                              controller: _accountController,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(30.0),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "校网密码",
                              hintText: "请输入您校网的密码",
                              counterText: '仅用于身份验证，并将作为您的初始密码',
                              prefixIcon: Icon(Icons.password_outlined),
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
                            onChanged: _checkInputValid,
                            obscureText: _ifhide,
                            controller: _passwordController,
                          ),
                        ),
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
                          height: 20,
                        ),
                        SizedBox(
                          //padding: const EdgeInsets.all(30.0),
                          height: 50.0,
                          width: 200.0,
                          child: ElevatedButton(
                            onPressed: () async {
                              _checkInputValid;
                              //存在信息未填写
                              if (!isInputValid) {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text('存在信息未填写'),
                                        ));
                              } else if (_ifacceptAgreement == false) {
                                //请先阅读并同意《隐私政策》和《用户协议》
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          content: Text('请先阅读并同意《隐私政策》和《用户协议》'),
                                        ));
                              } else {
                                //print('111111');
                                //验证身份
                                var isfzyzer = await CheckFzyzerID(
                                    _accountController.text,
                                    _passwordController.text,
                                    context);

                                //print('isfzyzer:$isfzyzer');

                                if (isfzyzer == 2 || isfzyzer == 3) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: Text('身份验证失败'),
                                          ));
                                } else //注册成功
                                {
                                  await RegisterApp(isfzyzer);
                                  if (canRegister) {
                                    LCUser user = await LCUser.login(
                                        _accountController.text,
                                        _passwordController.text);
                                    /*
                                    await Provider.of<TokenUtil>(context,
                                            listen: false)
                                        .saveLoginInfo(user);*/
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text('注册成功'),
                                          );
                                        });
                                    RouterUtil.toUserInitializationPage(
                                        context);
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                              content: Text('出现了错误，注册失败'),
                                            ));
                                  }
                                }
                              }

                              //canLogin ? _login : null;
                            },
                            child: const Text('注册'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(24.0),
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: Text(
                              '问题反馈',
                              textAlign: TextAlign.right,
                            ),
                            onPressed: () {
                              RouterUtil.toUserFeedbackPage(context);
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
