import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class AddDataCenter extends ChangeNotifier {
  //static _AddDataCenter _instance = _AddDataCenter();

  List<LCObject> get addgoodList => _addgoodList;

  List<LCObject> _addgoodList = [];
  List<String> _title = [], _price = [], _img = [], _pubdate = [];

  //int _itemCount = 0;

  //UnmodifiableListView<LCObject> get addgoodList => UnmodifiableListView(addgoodList);

  int get getaddCount => addgoodList.length;

  initData(BuildContext context) async {
    var user = context.read<TokenUtil>().localuser;
    try {
      LCQuery<LCObject> query = LCQuery('good');
      query.whereEqualTo('providerId', user.objectId);
      query.whereNotEqualTo('ifOnSell', true);

      List<LCObject>? tmp = await query.find();
      if (tmp == null) {
      } else {
        //addgoodList = tmp;
        addgoodList.clear();
        addgoodList.addAll(tmp);

        //print('tmp:$tmp');
        //print('addgoodList:$addgoodList');
        //int _itemCount = addgoodList.length;
        //print('addgoodList:$_itemCount');
        notifyListeners();
      }
    } on LCException catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }

    notifyListeners();
  }

  addgood(String isbn, BuildContext context) async {
    var user = context.read<TokenUtil>().localuser;
    LCObject newgood = LCObject('good');
    newgood['ISBN'] = isbn;
    newgood['providerId'] = user.objectId;
    newgood['providerName'] = user['nickname'];
    newgood['providerClass'] = user['class'];
    newgood['providerGrade'] = user['grade'];

    _addgoodList.add(newgood);

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', isbn);
    var tmp = await query.first();

    if (tmp != null) {
      newgood['goodtitle'] = tmp['title'];
      newgood['goodprice'] = tmp['price'] ?? '?';
      newgood['goodimage'] = tmp['img'] ?? '?';
      newgood['goodpubdate'] = tmp['pubdate'] ?? '?';
      if (tmp['subject'] != null) newgood['subject'] = tmp['subject'];
      if (tmp['tags'] != null) newgood['tags'] = tmp['tags'];

      //不能在这里加，要在上架的时候加
      //tmp['providerCount']++;

      //print(tmp['providerCount']);
      //await tmp.save();
    }

    await newgood.save();

    //int k = addgoodList.length;
    //print('addlistcount:$k');

    notifyListeners();
    //print('addsuccess');
  }

  delgood(LCObject newgood) async {
    await newgood.delete();
    _addgoodList.remove(newgood);

    //_addgoodList[1].remove
    notifyListeners();
  }

  changeOnSellState(int index, bool ifOnsell) async {
    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var tmp = await query.first();

    if (tmp != null) {
      if (ifOnsell == false) {
        --tmp['providerCount'];
      } else {
        ++tmp['providerCount'];
      }
      await tmp.save();
    }

    //print('修改上架状态');
    _addgoodList[index]['ifOnSell'] = ifOnsell;
    //print('22222222${_addgoodList[index]['ifOnSell']}');
    await _addgoodList[index].save();
    notifyListeners();
    //print('333333333${_addgoodList[index]['ifOnSell']}');

    //print('上架状态上传云端');
  }

  changeifDirectBuy(int index, bool ifDirectBuy) async {
    //print('修改上架状态');
    _addgoodList[index]['ifDirectBuy'] = ifDirectBuy;
    //print('22222222${_addgoodList[index]['ifOnSell']}');
    await _addgoodList[index].save();
    notifyListeners();
    //print('333333333${_addgoodList[index]['ifOnSell']}');

    //print('上架状态上传云端');
  }

  save(LCObject good) async {
    await good.save();
    notifyListeners();
  }

  changeNewold(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['newold'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('新旧上传云端');
    notifyListeners();
  }

  changeVersion(int index, String version) async {
    _addgoodList[index]['version'] = version;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('版本上传云端');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var tmp = await query.first();
    if (tmp != null) {
      tmp['version'] = version;
      await tmp.save();
    }
    notifyListeners();
    /*
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var tmp = await query.first();
    if (tmp != null) {
      if (tmp['tags'].contains(_addgoodList[index]['version']))
        tmp['tags'].remove(_addgoodList[index]['version']);
      if (tmp['tags'].contains(version) == false) {
        tmp['tags'].add(version);
        tmp.save();
      }
    }
    */

    
  }

  changeDeliveryTime(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['deliveryTime'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('发货上传云端');
    notifyListeners();
  }

  changePrice(int index, String tmp) async {
    //print('进入priceprovider设置');
    _addgoodList[index]['sellprice'] = tmp;

    _addgoodList[index]['realprice'] =
        CaculateRealPrice(tmp, double.parse(_addgoodList[index]['goodprice']));
    //print('211111111111');
    await _addgoodList[index].save();
    //print('价格上传云端');
    notifyListeners();
  }

  changeflaw(int index, String i, bool ifadd) async {
    //

    if (ifadd == true) {
      _addgoodList[index].addUnique('flaws', i);
    } else {
      _addgoodList[index].remove('flaws', i);
    }

    await _addgoodList[index].save();

    notifyListeners();
  }

  changetag(int index, String i, bool ifadd) async {
    if (ifadd == true) {
      _addgoodList[index].addUnique('tags', i);
    } else {
      _addgoodList[index].remove('tags', i);
    }
    await _addgoodList[index].save();

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
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

  changeSubject(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['subject'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('学科上传云端');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['subject'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookTitle(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['goodtitle'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('修改书名');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['title'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookPrice(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['goodprice'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('修改价格');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
    var book = await query.first();

    if (book != null) {
      book['price'] = tmp;
      await book.save();
    }

    notifyListeners();
  }

  changeBookPubdate(int index, String tmp) async {
    //print('进入newoldprovider设置');

    _addgoodList[index]['goodpubdate'] = tmp;
    //print('设置新旧${_addgoodList[index]['newold']}');
    await _addgoodList[index].save();
    //print('修改版本');

    LCQuery<LCObject> query = LCQuery('product');
    query.whereEqualTo('ISBN', _addgoodList[index]['ISBN']);
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
