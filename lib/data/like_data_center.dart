import 'package:MOYU/utils/token_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class LikeDataCenter extends ChangeNotifier {
  List<LCObject> get likeList => _likeList;
  List<LCObject> get likegoodList => _likegoodList;

  List<LCObject> _likeList = [];
  List<LCObject> _likegoodList = [];
  //var user, _userId;

  int get getlikeCount => likeList.length;

  initData(BuildContext context) async {
    var user = context.read<TokenUtil>().localuser;

    try {
      LCQuery<LCObject> query = LCQuery('Like');
      query.whereEqualTo('userId', user.objectId);
      List<LCObject>? tmp = await query.find();
      if (tmp == null) {
      } else {
        //likeList = tmp;
        likeList.clear();
        likegoodList.clear();
        likeList.addAll(tmp);

        for (int i = 0; i < likeList.length; i++) {
          LCQuery<LCObject> querygood = LCQuery('good');
          querygood.whereEqualTo('objectId', likeList[i]['goodId']);
          _likegoodList.add(await querygood.first() ?? LCObject('good'));
        }

        //print('tmp:$tmp');
        //print('likeList:$likeList');
        //int _itemCount = likeList.length;
        //print('likeList:$_itemCount');
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

  addlike(LCObject good, BuildContext context) async {
    var user = context.read<TokenUtil>().localuser;
    if (_likegoodList.contains(good)) return;

    LCObject newlikegood = LCObject('Like');
    newlikegood['goodId'] = good.objectId;
    //newlikegood['goodImage'] = good['goodimage'];
    //newlikegood['goodName'] = good['goodtitle'];
    //newlikegood['goodPrice'] = good['realprice'].toString();
    newlikegood['ISBN'] = good['ISBN'];
    //newlikegood['deliveryTime'] = good['deliveryTime'];

    //newlikegood['buyer'] = user;

    newlikegood['userId'] = user.objectId;
    newlikegood['ifOnSell'] = true;

    _likeList.add(newlikegood);
    _likegoodList.add(good);

    await newlikegood.save();

    //int k = likeList.length;
    //print('addlistcount:$k');

    notifyListeners();
  }

  dellikegoodInList(LCObject dellikegood, int index) async {
    //print('enter del index:$index');
    //print('dellikegood: $dellikegood');
    var k = _likeList.length;
    //print('likelistcount:$k');
    //print('_likeList[index]: ${_likeList[index]}');
    _likeList.remove(dellikegood);
    _likegoodList.removeAt(index);

    await dellikegood.delete();

    notifyListeners();
  }

  dellikegoodInProduct(LCObject dellikegooditem) async {
    //print('enter del index:$index');
    //print('dellikegood: $dellikegood');
    var k = _likeList.length;
    //print('likelistcount:$k');
    //print('_likeList[index]: ${_likeList[index]}');
    _likegoodList.remove(dellikegooditem);

    var index = _likeList
        .indexWhere((element) => element['goodId'] == dellikegooditem.objectId);
    await _likeList[index].delete();
    _likeList.removeAt(index);

    notifyListeners();
  }

  /*changeCheckState(int index) async {
    if (_likeList[index]['isChecked'] == true) {
      _likeList[index]['isChecked'] = false;
    } else {
      _likeList[index]['isChecked'] = true;
    }
    await _likeList[index].save();
    notifyListeners();
  }*/
}
