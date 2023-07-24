import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/data/add_data_center.dart';
import 'package:MOYU/data/like_data_center.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/data/on_sell_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var username = context.watch<TokenUtil>().username;
    var user = context.watch<TokenUtil>().localuser;
    int graduates =
        int.parse(DateTime.now().year.toString().substring(2, 4)) - 3;
    if (int.parse(DateTime.now().month.toString()) < 9) graduates -= 1;
    //print('user!!!!!!!!!!!');
    //print(username);
    //print(user);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text('我的'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  RouterUtil.toUserSettingPage(context);
                  //RouterUtil.toOrderSuccessPage(context);
                },
                icon: const Icon(Icons.settings_applications))
          ]),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              //height: 50,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: (MediaQuery.of(context).size.width) * 0.3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //昵称
                    Container(
                      margin: EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            //nickname,
                            //username.toString(),
                            user['nickname'].toString(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            height: 10,
                          ),
                          user.username == null
                              ? Text(
                                  'null',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis),
                                )
                              : Text(
                                  //'高'+grade+'('+clas+')班',
                                  int.parse((user.username)!.substring(1, 3)) <=
                                          graduates
                                      ? '${(user.username)!.substring(1, 3)}级 ${user['class']}班 校友'
                                      : '${user['grade']}年级 ${user['class']}班 在读',
                                  //'',
                                  //'$grade级 $clas班',
                                  //clas,
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 17,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            Container(
              margin: const EdgeInsets.all(10.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //未售
                  Container(
                    decoration: DefaultDecoration.homePageItemDec,
                    child: InkWell(
                      onTap: () async {
                        Provider.of<AddDataCenter>(context, listen: false)
                            .initData(context);
                        RouterUtil.toAddProductPage(context);
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(
                            Icons.sell_outlined,
                            size: 30,
                          ),
                          Text('待售')
                        ],
                      ),
                    ),
                  ),
                  //在售商品
                  Container(
                    decoration: DefaultDecoration.homePageItemDec,
                    child: InkWell(
                      onTap: () async {
                        Provider.of<OnSellDataCenter>(context, listen: false)
                            .initData(context);
                        /*
                        await showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), (() {
                                RouterUtil.pop(context);
                              }));
                              return Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: LoadingWidget(context)));
                            });
                            */
                        RouterUtil.toUserOnSellGoodsPage(context);
                      },
                      child: Column(
                        children: const <Widget>[
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 30,
                          ),
                          Text('在售')
                        ],
                      ),
                    ),
                  ),
                  //购物车

                  Container(
                    decoration: DefaultDecoration.homePageItemDec,
                    child: InkWell(
                      onTap: () async {
                        Provider.of<LikeDataCenter>(context, listen: false)
                            .initData(context);
                        RouterUtil.toUserLikePage(context);
                      },
                      child: Container(
                        child: Column(
                          children: const [
                            Icon(
                              Icons.favorite_outline,
                              size: 30,
                            ),
                            Text('收藏')
                          ],
                        ),
                      ),
                    ),
                  ),

                  //购物车
                  /*
                  Container(
                    decoration: DefaultDecoration.homePageItemDec,
                    child: InkWell(
                      onTap: () async {
                        Provider.of<CartDataCenter>(context, listen: false)
                            .initData();
                        /*
                        await showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), (() {
                                RouterUtil.pop(context);
                              }));
                              return Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: LoadingWidget(context)));
                            });
                            */
                        RouterUtil.toCartPage(context);
                      },
                      child: Column(
                        children: const [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 30,
                          ),
                          Text('购物车')
                        ],
                      ),
                    ),
                  ),
                  //订单页
                  Container(
                    decoration: DefaultDecoration.homePageItemDec,
                    child: InkWell(
                      onTap: () async {
                        Provider.of<orderDataCenter>(context, listen: false)
                            .initData();
                        /*
                        await showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 2), (() {
                                RouterUtil.pop(context);
                              }));
                              return Container(
                                  height: 50,
                                  width: 50,
                                  child: Center(child: LoadingWidget(context)));
                            });*/
                        RouterUtil.toUserOrderPage(context);
                      },
                      child: Column(
                        children: const [
                          Icon(
                            Icons.assessment_outlined,
                            size: 30,
                          ),
                          Text('订单')
                        ],
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: DefaultDecoration.gooditemDec,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}


//String nickname = "", account = "", clas = "", grade = "";
  //LCObject neww = LCObject('good');
  //List<LCObject> k = [];

  //bool _isLogin = false;

  /*

  _checkLogin() async {
    bool login = await TokenUtil().isLogin();
    var user = await TokenUtil.getUserInfo();
    this.setState(() {
      _isLogin = login;
      nickname = user['nickname'];
      clas = user['class'];
      grade = user['grade'];
    });
  }

  void getUserInfo() async {
    if (_isLogin == true) {
      LCUser? currentUser = await LCUser.getCurrent();
      account = (await currentUser?.username)!;
      nickname = await currentUser!['nickname'];
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('提示'),
              content: Text('请先登录'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => RouterUtil.toLoginPage(context),
                    child: Text('登录')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('取消'))
              ],
            );
          });
    }
  }
  */
