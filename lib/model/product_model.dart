import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:MOYU/utils/token_util.dart';
import 'package:leancloud_storage/leancloud.dart';

class ProductModel extends ChangeNotifier {
  LCObject _bookinfo = LCObject('product');
  List<LCObject> _sellerList = [];
  List<LCUser> _providerList = [];


  LCObject get bookinfo => _bookinfo;

  List<LCObject> get sellerList => _sellerList;
  List<LCObject> get providerList => _providerList;
  int get getsellerCount => sellerList.length;

  initData(String isbn, BuildContext context) async {
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereEqualTo('ISBN', isbn);
      _bookinfo = (await query.first())!;
      //print("bookinfo:$_bookinfo");

      query = LCQuery('good');
      query.whereEqualTo('ISBN', isbn);
      query.whereEqualTo('ifsold', false);
      query.whereEqualTo('ifOnSell', true);
      _sellerList = (await query.find())!;

      //print('_sellerList:$_sellerList');

      //for (int i = 0; i < _sellerList.length; i++) {
      //_providerList[i] = (await LCUser.(_sellerList[i]['providerId']));
      //}

      notifyListeners();
    } on LCException catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }

    notifyListeners();
  }
  /*

  Future<void> addseller(LCObject seller) async {
    _sellerList.add(seller);
    seller['buyerID'] = user['objectId'].toString();
    await seller.save();
    //int k = sellerList.length;
    //print('addlistcount:$k');

    notifyListeners();
  }

  Future<void> finishseller(LCObject seller) async {
    seller['ifFinished'] = true;
    await seller.save();
    //int k = sellerList.length;
    //print('addlistcount:$k');

    notifyListeners();
  }

  Future<void> cancelseller(LCObject cancelseller) async {
    //print('enter del index:$index');
    //print('cancelseller: $cancelseller');
    //var k = _sellerList.length;
    //print('sellerlistcount:$k');
    //print('_sellerList[index]: ${_sellerList[index]}');
    _sellerList.remove(cancelseller);

    await cancelsellerincloud(cancelseller);
    notifyListeners();
  }*/

  cancelsellerincloud(LCObject cancelseller) async {
    await cancelseller.delete();
  }

  LCUser provider = LCUser();
  contactProvider(providerId) async {    
    LCQuery<LCUser> query = LCUser.getQuery();
    var tmp=await query.get(providerId);
    if (tmp!=null)provider = tmp;
    notifyListeners();
  }
}
