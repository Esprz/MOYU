import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leancloud_storage/leancloud.dart';

class SearchResultDataCenter extends ChangeNotifier {
  List<LCObject> get searchResultList => _searchResultList;

  List<LCObject> _searchResultList = [];

  int get getsearchResultCount => searchResultList.length;

  String _subject = '', _bookname = '';
  List<String> _tags = [];
  List<String> _versions = [];
  int total = 0;

  initSearchData(String bookname, List<String> tags, String subject,List<String> versions,
      BuildContext context) async {
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereNotEqualTo('providerCount', 0);
      query.limit(20);

      if (versions.isNotEmpty) {
        query.whereContainedIn(
          'version',
          versions,
        );
        _versions.clear();
        _versions.addAll(versions);
        //print('111111111111');
        //print(tags);
      }

      if (tags.isNotEmpty) {
        query.whereContainedIn(
          'tags',
          tags,
        );
        _tags.clear();
        _tags.addAll(tags);
        //print('111111111111');
        //print(tags);
      }
      if (bookname != '') {
        query.whereContains('title', bookname);
        _bookname = bookname;
        //print('222222222222');
      }
      if (subject != '全部' && subject != '' && subject != '教辅') {
        query.whereEqualTo('subject', subject);
        _subject = subject;
        //print('3');
      } else if (subject == '教辅') {
        query.whereNotContainedIn('tagd', ['工具书']);
        _subject = subject;
      }

      List<LCObject>? tmp = await query.find();
      total = await query.count();

      searchResultList.clear();
      if (tmp == null) {
      } else {
        //searchResultList = tmp;

        searchResultList.addAll(tmp);
        //print('tmp:$tmp');
        //print('searchResultList:$searchResultList');
        //int _itemCount = searchResultList.length;
        //print('searchResultList:$_itemCount');
      }
    } on LCException catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }

    notifyListeners();
  }

  refreshSearchData(BuildContext context) async {
    if (_searchResultList.length >= total) return;
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereNotEqualTo('providerCount', 0);
      query.limit(20);
      query.skip(searchResultList.length);
      query.orderByDescending('createAt');

      if (_tags.isNotEmpty) {
        query.whereContainsAll(
          'tags',
          _tags,
        );
        //print('111111111111');
        //print(tags);
      }
      if (_bookname != '') {
        query.whereContains('title', _bookname);
        //print('222222222222');
      }
      if (_subject != '全部' && _subject != '' && _subject != '教辅') {
        query.whereEqualTo('subject', _subject);
        //print('3');
      } else if (_subject == '教辅') {
        query.whereNotContainedIn('tagd', ['工具书']);
      }

      List<LCObject>? tmp = await query.find();
      //searchResultList.clear();
      if (tmp == null) {
      } else {
        //searchResultList = tmp;

        searchResultList.addAll(tmp);
        //print('tmp:$tmp');
        //print('searchResultList:$searchResultList');
        //int _itemCount = searchResultList.length;
        //print('searchResultList:$_itemCount');
      }
    } on LCException catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }

    notifyListeners();
  }
  /*

  initTutorialBooks(BuildContext context) async {
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereNotEqualTo('providerCount', 0);
      query.whereNotContainedIn('tags', ['工具书']);
      List<LCObject>? tmp = await query.find();
      if (tmp == null) {
      } else {
        //searchResultList = tmp;
        searchResultList.clear();
        searchResultList.addAll(tmp);
        //print('tmp:$tmp');
        //print('searchResultList:$searchResultList');
        //int _itemCount = searchResultList.length;
        //print('searchResultList:$_itemCount');
      }
    } on Exception catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.toString()}')));
    }

    notifyListeners();
  }

  initReferenceBooks(BuildContext context) async {
    try {
      LCQuery<LCObject> query = LCQuery('product');
      query.whereNotEqualTo('providerCount', 0);
      query.whereContains('tags', '工具书');
      List<LCObject>? tmp = await query.find();
      if (tmp == null) {
      } else {
        //searchResultList = tmp;
        searchResultList.clear();
        searchResultList.addAll(tmp);
        //print('tmp:$tmp');
        //print('searchResultList:$searchResultList');
        //int _itemCount = searchResultList.length;
        //print('searchResultList:$_itemCount');
      }
    } on Exception catch (e) {
      // TODO
      //print('${e.hashCode} : ${e.runtimeType}');

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.toString()}')));
    }

    notifyListeners();
  }*/
}
