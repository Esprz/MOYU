import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class OnSellDataCenter extends ChangeNotifier {
  List<LCObject> get onsellgoodList => _onsellgoodList;

  List<LCObject> _onsellgoodList = [];
  int get getCount => onsellgoodList.length;

  deleteGood(LCObject k) async {
    LCQuery query = LCQuery('Like');
    query.whereEqualTo('goodId', k.objectId!);
    var tmp = await query.find();
    if (tmp != null) LCObject.deleteAll(tmp);

    LCQuery<LCObject> q2 = LCQuery('product');
    q2.whereEqualTo('ISBN', k['ISBN']);
    var tmp2 = await q2.first();

    if (tmp2 != null) {
      --tmp2['providerCount'];
      await tmp2.save();
    }

    _onsellgoodList.remove(k);
    await k.delete();
    notifyListeners();
  }

  initData(BuildContext context) async {
    var user = context.read<TokenUtil>().localuser;

    try {
      LCQuery<LCObject> query = LCQuery('good');
      query.whereEqualTo('providerId', user.objectId);
      query.whereEqualTo('ifOnSell', true);
      query.whereEqualTo('ifsold', false);

      List<LCObject>? tmp = await query.find();
      if (tmp == null) {
      } else {
        //onsellgoodList = tmp;
        onsellgoodList.clear();
        onsellgoodList.addAll(tmp);
        //print('tmp:$tmp');
        //print('onsellgoodList:$onsellgoodList');
        int _itemCount = onsellgoodList.length;
        //print('onsellgoodList:$_itemCount');
        notifyListeners();
      }

      //if (tmp != null) {
      //_itemCount = AddDataCenter().getLength();
      //_itemCount = tmp.length;
      //print(tmp);
      //print('getlength:$_itemCount');

      //print(AddDataCenter().getonsellGoodList());
      //} else {
      //  _itemCount = 0;
      //}

      //_refresh = !_refresh;

      //print('_userId:$_userId');
    } on LCException catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }

    notifyListeners();
  }
}
