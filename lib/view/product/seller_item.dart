import 'package:MOYU/data/like_data_center.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SellerItem extends StatelessWidget {
  //const SellerItem({ Key? key }) : super(key: key);

  LCObject item = LCObject('good');
  int disadCount = 0;
  SellerItem(this.item);

  Widget _ActionBox(LCObject item, BuildContext context) {
    //LCUser user = context.read<TokenUtil>().localuser;

    var likestate = context.watch<LikeDataCenter>().likeList;

    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //联系方式
          IconButton(
              onPressed: () async {
                await Provider.of<ProductModel>(context, listen: false)
                    .contactProvider(item['providerId']);
                LCUser provider = context.read<ProductModel>().provider;                
                showDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('联系方式'),
                        content: Text('点按复制对应号码',style: TextStyle(color: Colors.black45,height: 2),),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${provider['phoneNum'] ?? '无'}'));
                              },
                              child:
                                  Text('手机: ${provider['phoneNum'] ?? '无'} ')),
                          TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${provider['qq'] ?? '无'}'));
                              },
                              child: Text('QQ:${provider['qq'] ?? '无'}')),
                          TextButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: '${provider['wechat'] ?? '无'}'));
                              },
                              child: Text('微信:${provider['wechat'] ?? '无'}')),
                        ],
                      );
                    });

                //content: Text('很抱歉，通讯功能暂未开通，继续期待，开发人员正在努力码字中……'),
                ;
              },
              icon: Icon(
                Icons.comment,
              )),
          //收藏
          IconButton(
              focusNode: FocusNode(),
              onPressed: () async {
                var likeList = context.read<LikeDataCenter>().likeList;

                if (likeList
                    .any((element) => element['goodId'] == item.objectId)) {
                  await Provider.of<LikeDataCenter>(context, listen: false)
                      .dellikegoodInProduct(item);
                  //print('111111111111111');
                  /*
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1),
                            (() => RouterUtil.pop(context)));

                        return AlertDialog(
                          content: Text('已收藏'),
                        );
                      });*/
                } else {
                  //print('222222222222222222222');
                  await Provider.of<LikeDataCenter>(context, listen: false)
                      .addlike(item, context);
                  /*
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1),
                            (() => RouterUtil.pop(context)));
                        return AlertDialog(
                          content: Text('收藏成功'),
                        );
                      });*/
                }
              },
              icon: Icon(
                (likestate.any((element) => element['goodId'] == item.objectId)
                    ? Icons.favorite
                    : Icons.favorite_outline),
              )),

          //收藏原为购物车
          /*
          IconButton(
              focusNode: FocusNode(),
              onPressed: () async {
                var cartList = context.read<CartDataCenter>().cartList;
                //print('00000000000000000 item.objectId');
                //print(item.objectId);
                //print('0000000011111111111 goodId');
                /*
                for (int i = 0; i < cartList.length; i++) {
                  print(cartList[i]['goodId']);
                }
                print('000000002222222222222');
                //print(cartList);
                */
                if (cartList
                    .any((element) => element['goodId'] == item.objectId)) {
                  //print('111111111111111');
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1),
                            (() => RouterUtil.pop(context)));

                        return AlertDialog(
                          content: Text('已在购物车中'),
                        );
                      });
                } else {
                  //print('222222222222222222222');
                  await Provider.of<CartDataCenter>(context, listen: false)
                      .addcart(item);
                  showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(Duration(seconds: 1),
                            (() => RouterUtil.pop(context)));
                        return AlertDialog(
                          content: Text('加入成功'),
                        );
                      });
                }
              },
              icon: Icon(
                Icons.shopping_cart,
              ))*/
        ],
      ),
    );
  }

  Widget _Others(LCObject item, BuildContext context) {
    if (item['flaws'] != null) disadCount = item['flaws'].length;
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width * 0.7,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Chip(label: Text(item['newold'].toString())),
            Container(width: 10),
            Chip(label: Text('原价的${item['sellprice'].toString()}')),
            Container(width: 10),
            Chip(label: Text('${item['deliveryTime'].toString()}发货')),
            Container(width: 10),
          ])),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            ((context, index) {
              return Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Chip(label: Text(item['flaws'][index].toString())));
            }),
            childCount: disadCount,
          ))
        ],
      ),
    );
  }

  Widget _Name(LCObject item, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Row(
        children: [
          Text(
            item['providerName'].toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            '  ${item['providerGrade'].toString()}年级 ${item['providerClass'].toString()}班',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _Price(LCObject item, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        '￥${item['realprice']}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _Image(LCObject item, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      width: MediaQuery.of(context).size.width * 0.3,
      child: FadeInImage.assetNetwork(
          placeholder: 'images/clip-loading.gif',
          image: item['goodimage'].toString()),
      //child: Image.network(item['goodimage'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.all(18),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Name(item, context),
                Container(
                  height: 5,
                ),
                _Price(item, context),
                Container(
                  height: 5,
                ),
                _Others(item, context),
              ],
            ),
          ),
          Container(
            child: _ActionBox(item, context),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }
}
