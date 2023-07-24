import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/data/like_data_center.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserLikePage extends StatelessWidget {
  UserLikePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var likegood = context.watch<LikeDataCenter>();
    return Scaffold(
      appBar: AppBar(
        title: Text('收藏'),
        centerTitle: true,
      ),
      body: Scrollbar(
        showTrackOnHover: true,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                  margin: EdgeInsets.all(3),
                  alignment: Alignment.center,
                  child: Text(
                    '卖家已清除的商品将自动为您从列表内删除',
                    style: TextStyle(color: Colors.black38),
                  )),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                child: InkWell(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              content: Text('确认删除？'),
                              actions: [
                                CupertinoDialogAction(
                                  textStyle: TextStyle(color: Colors.black),
                                  child: Text('确认'),
                                  onPressed: () async {
                                    await Provider.of<LikeDataCenter>(context,
                                            listen: false)
                                        .dellikegoodInList(
                                            likegood.likeList[index], index);
                                    RouterUtil.pop(context);
                                  },
                                ),
                                CupertinoDialogAction(
                                    textStyle: TextStyle(color: Colors.black),
                                    child: Text('取消'),
                                    onPressed: () => RouterUtil.pop(context)),
                              ],
                            ));
                  },
                  onTap: () async {
                    await Provider.of<ProductModel>(context, listen: false)
                        .initData(likegood.likeList[index]['ISBN'], context);
                    RouterUtil.toProductPage(context);
                  },
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.zero,
                        width: MediaQuery.of(context).size.width,
                        decoration: DefaultDecoration.gooditemDec,
                        child: Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              //child: Image.network(),
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'images/clip-loading.gif',
                                  image: likegood.likegoodList[index]['goodimage']),
                            ),
                            Expanded(
                              child: ListTile(
                                //selectedColor: Colors.black45,
                                //selectedTileColor: Colors.black45,
                                //selected: likegood.likegoodList[index]['ifOnSell'],
                                //controlAffinity: ListTileControlAffinity.leading,
                                //title: likeGoodItem(likegood.likegood[index], index),
                                title: Text(
                                  likegood.likegoodList[index]['goodtitle'],
                                  maxLines: 1,
                                ),

                                subtitle: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Divider(),
                                      Text(
                                          '${likegood.likegoodList[index]['providerName']} (${likegood.likegoodList[index]['providerGrade']}年级${likegood.likegoodList[index]['providerClass']}班)'),
                                      /*
                                      Text(likegood.likegoodList[index]
                                                  ['ifDirectBuy'] ==
                                              true
                                          ? '可直接拍下'
                                          : '需经卖家同意才能通过订单'),*/
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 35,
                                        alignment: Alignment.center,
                                        child: CustomScrollView(
                                          scrollDirection: Axis.horizontal,
                                          slivers: [
                                            SliverList(
                                                delegate:
                                                    SliverChildListDelegate([
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(likegood
                                                      .likegoodList[index]
                                                          ['version']
                                                      .toString())),
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(likegood
                                                      .likegoodList[index]
                                                          ['newold']
                                                      .toString())),
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(likegood
                                                      .likegoodList[index]
                                                          ['deliveryTime']
                                                      .toString())),
                                            ])),
                                            if (likegood.likegoodList[index]
                                                    ['tags'] !=
                                                null)
                                              SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                          (context, i) {
                                                return Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(likegood
                                                      .likegoodList[index]
                                                          ['tags'][i]
                                                      .toString()),
                                                );
                                              },
                                                          childCount: likegood
                                                              .likegoodList[
                                                                  index]['tags']
                                                              .length)),
                                            if (likegood.likegoodList[index]
                                                    ['flaws'] !=
                                                null)
                                              SliverList(
                                                  delegate:
                                                      SliverChildBuilderDelegate(
                                                          (context, j) {
                                                return Container(
                                                  padding:
                                                      EdgeInsets.only(right: 5),
                                                  child: Text(likegood
                                                      .likegoodList[index]
                                                          ['flaws'][j]
                                                      .toString()),
                                                );
                                              },
                                                          childCount: likegood
                                                              .likegoodList[
                                                                  index]
                                                                  ['flaws']
                                                              .length)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //secondary: Image.network(likegood.likegoodList[index]['goodimage']),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Text(
                          '￥${likegood.likegoodList[index]['realprice']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        bottom: 10.0,
                        right: 30.0,
                      ),
                      Positioned.fill(
                          child: Opacity(
                              opacity: likegood.likegoodList[index]
                                          ['ifOnSell'] ==
                                      false
                                  ? 0.6
                                  : 0,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.zero,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black38,
                                ),
                                //child: Center(child: ),
                              ))),
                      Positioned.fill(
                          child: Opacity(
                              opacity: likegood.likegoodList[index]
                                          ['ifOnSell'] ==
                                      false
                                  ? 1
                                  : 0,
                              child: Center(
                                child: Text(
                                  '已失效',
                                  style: TextStyleDefault.IndividualText,
                                ),
                              )))
                    ],
                  ),
                ),
              );
            }, childCount: likegood.getlikeCount)),
          ],
        ),
      ),
    );
  }
}
