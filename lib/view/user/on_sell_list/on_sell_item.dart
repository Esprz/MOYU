import 'package:MOYU/utils/router_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/data/on_sell_data_center.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class OnSellItem extends StatelessWidget {
  //const OnSellItem({ Key? key }) : super(key: key);

  LCObject item = LCObject('good');
  int disadCount = 0;

  OnSellItem(this.item);

  Widget _CheckBox(LCObject item, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
              onPressed: () {
                this._goodDelete(item, context);
              },
              icon: Icon(
                Icons.delete,
              ))
        ],
      ),
    );
  }

  Widget _Others(LCObject item, BuildContext context) {
    //if (item['flaws'] != null) disadCount = item['flaws'].length;
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: 35,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(item['version'].toString())),
            Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(item['newold'].toString())),
            Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(item['deliveryTime'].toString())),
          ])),
          if (item['tags'] != null)
            SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
              return Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(item['tags'][i].toString()),
              );
            }, childCount: item['tags'].length)),
          if (item['flaws'] != null)
            SliverList(
                delegate: SliverChildBuilderDelegate((context, j) {
              return Container(
                padding: EdgeInsets.only(right: 5),
                child: Text(item['flaws'][j].toString()),
              );
            }, childCount: item['flaws'].length)),
        ],
      ),
    );
  }

  Widget _Name(LCObject item, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Text(
        item['goodtitle'].toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _Price(LCObject item, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: AutoSizeText(
        '原价:￥${item['goodprice']}  售价:￥${item['realprice']}',
        style: TextStyle(fontSize: 15),
        maxLines: 1,
      ),
    );
  }

  Widget _Image(LCObject item, BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width * 0.3,
      //child: Image.network(),
      child: FadeInImage.assetNetwork(
          placeholder: 'images/clip-loading.gif',
          image: item['goodimage'].toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.zero,

      decoration: DefaultDecoration.gooditemDec,

      child: Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _Image(item, context),
            Expanded(
              child: ListTile(
                title: _Name(item, context),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    _Price(item, context),
                    _Others(item, context),
                  ],
                ),
              ),
            ),
            _CheckBox(item, context),
          ],
        ),
      ),
      //child: Text('xxx'),
    );
  }

  _goodDelete(LCObject item, BuildContext context) async {
    //await item.delete();
    showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text('确认删除？'),
              content: Text('该操作不可恢复，系统将自动清除所有对您的商品的收藏（下架可恢复）'),
              actions: [
                CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.black),
                  child: Text('确认'),
                  onPressed: () async {
                    await Provider.of<OnSellDataCenter>(context, listen: false)
                        .deleteGood(item);
                    RouterUtil.pop(context);
                  },
                ),
                CupertinoDialogAction(
                    textStyle: TextStyle(color: Colors.black),
                    child: Text('取消'),
                    onPressed: () => RouterUtil.pop(context)),
              ],
            ));
  }
}
