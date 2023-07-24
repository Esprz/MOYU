import 'package:MOYU/data/change_onsell_data_center.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/data/on_sell_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/view/user/on_sell_list/on_sell_item.dart';
import 'package:provider/provider.dart';

class UserOnSellPage extends StatelessWidget {
  bool _isLogin = false;
  bool _refresh = false;

  @override
  Widget build(BuildContext context) {
    var onselllist = context.watch<OnSellDataCenter>();

    //var onselllist=context.read<OnSellDataCenter>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('在售商品'),
          centerTitle: true,
        ),
        body: Scrollbar(
          showTrackOnHover: true,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(3),
                      child: Text(
                        '点按进入商品详情，长按修改商品信息',
                        style: TextStyle(color: Colors.black54),
                      ))),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return InkWell(
                      onLongPress: () async {
                        await Provider.of<ChangeOnSellDataCenter>(context,
                                listen: false)
                            .initData(onselllist.onsellgoodList[index]);
                        RouterUtil.toOnSellItemPage(context);
                        //RouterUtil.toChangeProductAction(context, onselllist.onsellgoodList[index]);
                      },
                      onTap: () async {
                        await Provider.of<ProductModel>(context, listen: false)
                            .initData(onselllist.onsellgoodList[index]['ISBN'],
                                context);
                        RouterUtil.toProductPage(context);
                      },
                      child: OnSellItem(onselllist.onsellgoodList[index]));
                },
                childCount: onselllist.getCount,
              )),

              /*
              SliverToBoxAdapter(
                child: ListView.builder(
                  itemCount: onselllist.getCount,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onLongPress: () async {
                          await Provider.of<ChangeOnSellDataCenter>(context,
                                  listen: false)
                              .initData(onselllist.onsellgoodList[index]);
                          RouterUtil.toOnSellItemPage(context);
                          //RouterUtil.toChangeProductAction(context, onselllist.onsellgoodList[index]);
                        },
                        onTap: () async {
                          await Provider.of<ProductModel>(context, listen: false)
                              .initData(onselllist.onsellgoodList[index]['ISBN']);
                          RouterUtil.toProductPage(context);
                          
                        },
                        child: OnSellItem(onselllist.onsellgoodList[index]));
                    //return Text('$onselllist.getCount');
                  },
                ),
              ),*/
            ],
          ),
        ));
  }
}
