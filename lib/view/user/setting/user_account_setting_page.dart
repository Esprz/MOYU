import 'package:MOYU/componts/loading_widget.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserAccountSettingPage extends StatelessWidget {
  UserAccountSettingPage({Key? key}) : super(key: key);

  TextEditingController newcls = TextEditingController();
  TextEditingController newgrd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('账户设置'),
        ),
        body: Container(
          decoration: DefaultDecoration.gooditemDec,
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(children: [
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('修改班级'),
              onTap: () {
                _changeClass(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_rounded),
              title: Text('修改年段'),
              onTap: () {
                _changeGrade(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.password),
              title: Text('修改密码'),
              onTap: () {
                //_setPw(context);
                RouterUtil.toUserPasswordChangePage(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_rounded),
              title: Text('修改联系方式'),
              onTap: () {
                RouterUtil.toUserContactChangePage(context);
              },
            )
          ]),
        ),
      ),
    );
  }

  _changeClass(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
            title: Text('设置班级'),
            content: Container(
              margin: EdgeInsets.all(20),
              height: 160,
              child: Column(
                children: [
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: newcls,
                    decoration: InputDecoration(
                        label: Text('新班级：'),
                        hintText: '请输入数字1-16',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 15)
                        //errorText: '请输入数字1-16',
                        ),
                  ),
                  Container(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        int newclsnum = int.parse(newcls.text);
                        if (newclsnum >= 1 && newclsnum <= 16) {
                          await Provider.of<TokenUtil>(context, listen: false)
                              .setUserClass(newcls.text, context);
                          var error =
                              Provider.of<TokenUtil>(context, listen: false)
                                  .error;
                          if (error == '') {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text('修改成功'),
                                    ));
                            newcls.clear();
                          }
                        } else
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text('请输入正确的班级'),
                                  ));
                      },
                      child: Text('提交'))
                ],
              ),
            )));
  }

  _changeGrade(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
            title: Text('设置年段'),
            content: Container(
              margin: EdgeInsets.all(20),
              height: 160,
              child: Column(
                children: [
                  TextField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: newgrd,
                    decoration: InputDecoration(
                        label: Text('新年段：'),
                        hintText: '请输入数字10-12 (10年级即为高一，以此类推)',
                        hintStyle:
                            TextStyle(color: Colors.black38, fontSize: 15)
                        //errorText: '请输入数字1-16',
                        ),
                  ),
                  Container(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        int newgrdnum = int.parse(newgrd.text);
                        if (newgrdnum >= 10 && newgrdnum <= 12) {
                          Provider.of<TokenUtil>(context, listen: false)
                              .setUserGrade(newgrd.text, context);
                          await showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 2), (() {
                                  RouterUtil.pop(context);
                                }));
                                return Container(
                                    height: 50,
                                    width: 50,
                                    child:
                                        Center(child: LoadingWidget(context)));
                              });
                          var error =
                              Provider.of<TokenUtil>(context, listen: false)
                                  .error;
                          if (error == '') {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Text('修改成功'),
                                    ));
                            newgrd.clear();
                          }
                        } else
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: Text('请输入正确的年段'),
                                  ));
                      },
                      child: Text('提交'))
                ],
              ),
            )));
  }
}

class UserPasswordChangePage extends StatefulWidget {
  const UserPasswordChangePage({Key? key}) : super(key: key);

  @override
  State<UserPasswordChangePage> createState() => _UserPasswordChangePageState();
}

class _UserPasswordChangePageState extends State<UserPasswordChangePage> {
  var _ifhideold = true, _ifhidenew = true;
  TextEditingController oldpw = TextEditingController();
  TextEditingController newpw = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _ifhideold = true;
    _ifhidenew = true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('修改密码'),
        ),
        body: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                obscureText: _ifhideold,
                controller: oldpw,
                decoration: InputDecoration(
                  suffix: IconButton(
                    icon: _ifhideold == true
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _ifhideold = !_ifhideold;
                      });
                    },
                  ),
                  label: Text('原密码：'),
                ),
              ),
              Container(
                height: 15,
              ),
              TextField(
                obscureText: _ifhidenew,
                controller: newpw,
                decoration: InputDecoration(
                  label: Text('新密码：'),
                  suffix: IconButton(
                    icon: _ifhidenew == true
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _ifhidenew = !_ifhidenew;
                      });
                    },
                  ),
                ),
              ),
              Container(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (newpw.text != '' && oldpw.text != '') {
                      await Provider.of<TokenUtil>(context, listen: false)
                          .setUserPassword(oldpw.text, newpw.text, context);                      
                      /*
                      var error =
                          Provider.of<TokenUtil>(context, listen: false).error;
                      if (error == '') {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  content: Text('修改成功'),
                                ));
                      }*/
                    } else
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text('请输入新旧密码'),
                              ));
                  },
                  child: Container(
                      width: 70,
                      alignment: Alignment.center,
                      child: Text(
                        '提 交',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class UserContactChangePage extends StatelessWidget {
  UserContactChangePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('设置联系方式'),
        ),
        body: Container(
          decoration: DefaultDecoration.gooditemDec,
          margin: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(children: [
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('手机'),
              onTap: () {
                _changePhoneNum(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_rounded),
              title: Text('QQ'),
              onTap: () {
                _changeqq(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.password),
              title: Text('微信号'),
              onTap: () {
                _changeWechat(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  TextEditingController _contactInfoChange = TextEditingController();
  _changePhoneNum(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
              title: Text('修改手机号码'),
              content: Container(
                  //height: MediaQuery.of(context).size.width * 0.35,
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: '手机号码',
                            hintText: '输入手机号',
                            hintStyle: TextStyle(color: Colors.black38)),
                        controller: _contactInfoChange,
                      ),
                      Container(
                        height: 15,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            await Provider.of<TokenUtil>(context, listen: false)
                                .setUserPhoneNum(
                                    _contactInfoChange.text, context);
                            _contactInfoChange.clear();
                            RouterUtil.pop(context);
                          },
                          child: Text('提交'))
                    ],
                  )),
            ));
  }

  _changeqq(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
              title: Text('修改QQ号码'),
              content: Container(
                  //height: MediaQuery.of(context).size.width * 0.35,
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: 'QQ',
                            hintText: '输入QQ号',
                            hintStyle: TextStyle(color: Colors.black38)),
                        controller: _contactInfoChange,
                      ),
                      Container(
                        height: 15,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            await Provider.of<TokenUtil>(context, listen: false)
                                .setUserQQ(_contactInfoChange.text, context);
                            _contactInfoChange.clear();
                            RouterUtil.pop(context);
                          },
                          child: Text('提交'))
                    ],
                  )),
            ));
  }

  _changeWechat(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
              title: Text('修改微信'),
              content: Container(
                  //height: MediaQuery.of(context).size.width * 0.35,
                  height: 150,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: '微信号',
                            hintText: '输入微信号',
                            hintStyle: TextStyle(color: Colors.black38)),
                        controller: _contactInfoChange,
                      ),
                      Container(
                        height: 15,
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            await Provider.of<TokenUtil>(context, listen: false)
                                .setUserWechat(
                                    _contactInfoChange.text, context);
                            _contactInfoChange.clear();
                            RouterUtil.pop(context);
                          },
                          child: Text('提交'))
                    ],
                  )),
            ));
  }
}
