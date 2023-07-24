
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class ChangeOnSellDataCenter extends ChangeNotifier {
  //static _ChangeOnSellDataCenter _instance = _ChangeOnSellDataCenter();

  //List<LCObject> get changeonsellgoodList => _changeonsellgoodList;

  LCObject get changeonsellgood => _changeonsellgood;
  LCObject _changeonsellgood = LCObject('good');

  //List<LCObject> _changeonsellgoodList = [];
  List<String> _title = [], _price = [], _img = [], _pubdate = [];

  //int _itemCount = 0;

  //UnmodifiableListView<LCObject> get changeonsellgoodList => UnmodifiableListView(changeonsellgoodList);

  //int get getaddCount => changeonsellgoodList.length;

  initData(LCObject item) async {
    _changeonsellgood = item;
    notifyListeners();
  }

  changeOnSellState(bool ifOnsell) async {
    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var tmp = await query.first();

    if (tmp != null) {
      if (ifOnsell == false) {
        --tmp['providerCount'];
      } else {
        ++tmp['providerCount'];
      }
      await tmp.save();
    }

    /*

    LCQuery<LCObject> q2 = LCQuery('Like');
    q2.whereEqualTo('goodId', _changeonsellgood.objectId);
    var likers = await q2.find();*/

    //print('修改上架状态');
    _changeonsellgood['ifOnSell'] = ifOnsell;
    //print('22222222${_changeonsellgood['ifOnSell']}');
    await _changeonsellgood.save();
    notifyListeners();

    /*
    if (likers != null)
      likers.forEach((element) async {
        element['ifOnSell'] = ifOnsell;
        await element.save();
      });

    notifyListeners();*/

    //print('333333333${_changeonsellgood['ifOnSell']}');

    //print('上架状态上传云端');
  }

  changeifDirectBuy(bool ifDirectBuy) async {
    _changeonsellgood['ifDirectBuy'] = ifDirectBuy;
    await _changeonsellgood.save();
    notifyListeners();
  }

  save() async {
    await _changeonsellgood.save();
    notifyListeners();
  }

  changeNewold(String tmp) async {
    //print('进入newoldprovider设置');
    //print('设置新旧${_changeonsellgood['newold']}');
    //print('新旧上传云端');

    _changeonsellgood['newold'] = tmp;

    await _changeonsellgood.save();

    notifyListeners();
  }

  changeVersion(String tmp) async {
    _changeonsellgood['version'] = tmp;
    await _changeonsellgood.save();

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var book = await query.first();
    if (book != null) {
      book['version'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeDeliveryTime(String tmp) async {
    //print('进入newoldprovider设置');

    _changeonsellgood['deliveryTime'] = tmp;
    //print('设置新旧${_changeonsellgood['newold']}');
    await _changeonsellgood.save();
    //print('发货上传云端');
    notifyListeners();
  }

  changePrice(String tmp) async {
    //print('进入priceprovider设置');
    //print('211111111111');
    //print('价格上传云端');

    _changeonsellgood['sellprice'] = tmp;

    _changeonsellgood['realprice'] =
        CaculateRealPrice(tmp, double.parse(_changeonsellgood['goodprice']));

    await _changeonsellgood.save();

    notifyListeners();
  }

  changeflaw(String i, bool ifadd) async {
    //

    if (ifadd == true) {
      _changeonsellgood.addUnique('flaws', i);
    } else {
      _changeonsellgood.remove('flaws', i);
    }

    await _changeonsellgood.save();

    notifyListeners();
  }

  changetag(String i, bool ifadd) async {
    if (ifadd == true) {
      _changeonsellgood.addUnique('tags', i);
    } else {
      _changeonsellgood.remove('tags', i);
    }
    await _changeonsellgood.save();

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var tmp = await query.first();

    if (tmp != null) {
      if (ifadd == true) {
        tmp.addUnique('tags', i);
      } else {
        tmp.remove('tags', i);
      }
      await tmp.save();
    }

    notifyListeners();
  }

  changeSubject(String tmp) async {
    //print('进入newoldprovider设置');

    _changeonsellgood['subject'] = tmp;
    //print('设置新旧${_changeonsellgood['newold']}');
    await _changeonsellgood.save();
    //print('学科上传云端');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['subject'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookTitle(String tmp) async {
    //print('进入newoldprovider设置');

    _changeonsellgood['goodtitle'] = tmp;
    //print('设置新旧${_changeonsellgood['newold']}');
    await _changeonsellgood.save();
    //print('修改书名');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['title'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookPrice(String tmp) async {
    //print('进入newoldprovider设置');

    _changeonsellgood['goodprice'] = tmp;
    //print('设置新旧${_changeonsellgood['newold']}');
    await _changeonsellgood.save();
    //print('修改价格');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['price'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookPubdate(String tmp) async {
    _changeonsellgood['goodpubdate'] = tmp;
    await _changeonsellgood.save();
    //print('修改版本');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _changeonsellgood['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['pubdate'] = tmp;
      await book.save();
    }

    notifyListeners();
  }
}

CaculateRealPrice(String k, double preprice) {
  //print('1111333333111111');
  double res = 0;
  if (k == '免费转手') {
    return 0;
  } else {
    String l = k.replaceAll(RegExp('%'), '');
    //print(l);
    double ll = double.parse(l);
    //print(ll);
    res = ll / 100;
    res = res * preprice;
    //res.ceil();
    return res.ceilToDouble();
  }
}
