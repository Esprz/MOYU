import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class HomePageFeaturedModel extends ChangeNotifier {
  List<LCObject> _featured = [];
  List<LCObject> get featured => _featured;
  int get featuredCount => _featured.length;

  initData() async {
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereNotEqualTo('providerCount', 0);
      query.orderByDescending('createdAt');
      query.limit(10);
      
      List<LCObject>? tmp = await query.find();
      
      if (tmp == null) {
      } else {
        //_featured = tmp;
        _featured.clear();
        _featured.addAll(tmp);
        //print('tmp:$tmp');
        //print('_featured:$_featured');
        int _itemCount = _featured.length;
        //print('_featured:$_itemCount');
        notifyListeners();
      }
    } on Exception catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');
    }

    notifyListeners();
  }
}
