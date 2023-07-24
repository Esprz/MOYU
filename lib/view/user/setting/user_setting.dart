import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

class UserSettingPage extends StatefulWidget {
  const UserSettingPage({Key? key}) : super(key: key);

  @override
  State<UserSettingPage> createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  late double Screenwidth, Screenheight;
  bool _accountOpen = false,
      _notificationOpen = false,
      _aboutusOpen = false,
      _generalOpen = false,
      _isopen = false;

  ButtonStyle ContactWayDec = ButtonStyle(
      alignment: Alignment.centerLeft,
      //side: MaterialStateProperty.resolveWith((states) => BorderSide()),
      //elevation: MaterialStateProperty.resolveWith((states) => 1),
      //padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.zero),

      textStyle: MaterialStateTextStyle.resolveWith(
          (states) => TextStyle(fontWeight: FontWeight.normal)),
      foregroundColor:
          MaterialStateColor.resolveWith((states) => Colors.black));

  @override
  Widget build(BuildContext context) {
    var user = context.read<TokenUtil>().localuser;
    Screenheight = MediaQuery.of(context).size.height;
    Screenwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('设置'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          label: Text('退出账户'),
          icon: Icon(Icons.exit_to_app),
          onPressed: () async {
            await Provider.of<TokenUtil>(context, listen: false)
                .clearUserInfo(context);

            //dispose();
            RouterUtil.toLoginPage(context);
            dispose();
          },
        ),
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: DefaultDecoration.gooditemDec,
                    child: ListTile(
                      leading: Icon(Icons.manage_accounts),
                      title: Text('账户管理'),
                      onTap: () {
                        RouterUtil.toUserAccountSettingPage(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: DefaultDecoration.gooditemDec,
                    child: ListTile(
                      leading: Icon(Icons.help),
                      title: Text('用户反馈'),
                      onTap: () {
                        RouterUtil.toUserFeedbackPage(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: DefaultDecoration.gooditemDec,
                    child: ListTile(
                      leading: Icon(Icons.help),
                      title: Text('素材来源'),
                      onTap: () {
                        RouterUtil.toCopyrightNoticePage(context);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            RouterUtil.toPrivacyPolicyPage(context);
                          },
                          child: Text(
                            '隐私政策',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal),
                          )),
                      Container(
                        width: 5,
                      ),
                      TextButton(
                          onPressed: () {
                            RouterUtil.toUserAgreementPage(context);
                          },
                          child: Text(
                            '用户协议',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.normal),
                          ))
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  //bool _ac0 = false, _ac1 = false;

}


/*
For smartphone apps, please add a link to https://icons8.com in the about section or settings.

Also, please credit our work in your App Store or Google Play description (something like "Icons by Icons8" is fine).*/