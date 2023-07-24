import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leancloud_storage/leancloud.dart';

// ignore: non_constant_identifier_names
SearchISBN(String isbn, BuildContext context) async {
  Map res;
  try {
    var url = Uri.parse('https://way.jd.com/showapi/isbn');
    var response = await http.post(
      url,
      body: {'isbn': isbn, 'appkey': '88a8df560763b295dbaeb3b4abfa4f6e'},
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');
    res = JsonDecoder().convert(response.body);
    if (res['code'] == '10000' &&
        res['result']['showapi_res_body']['ret_code'] == 0) {
      await AddNewBookToCloud(res, isbn);
      return true;
    } else {}
  } on Exception catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('错误:${e.toString()}')));
    // TODO
    return false;
  }
  return false;
}

AddNewBookToCloud(Map res, String isbn) async {
  LCObject newbook = LCObject('product');

  newbook['ISBN'] = isbn;
  //newbook['tags'] = [];

  _assignment(String k) {
    if ((res['result']['showapi_res_body']['data'][k].toString() != "") &&
        (res['result']['showapi_res_body']['data'][k].toString() != "null")) {
      newbook[k] = res['result']['showapi_res_body']['data'][k].toString();
    }
  }

  _assignment('price');
  _assignment('pubdate');
  _assignment('title');
  //_assignment('author');
  //_assignment('binding');
  //_assignment('format');
  //_assignment('gist');
  _assignment('img');
  //_assignment('page');
  _assignment('publisher');

  List<String> subjects = [
    '语文',
    '数学',
    '英语',
    '物理',
    '化学',
    '生物',
    '历史',
    '地理',
    '政治',
    '体育',
    '音乐',
    '美术',
    '信息',
    '通用技术',
  ];
  List<String> tags = [
    '高一',
    '高二',
    '高三',
    '新教材',
    '旧教材',
    '工具书',
    '高中综合',
  ];

  for (int i = 0; i < subjects.length; i++) {
    if (newbook['title'].toString().contains(subjects[i])) {
      newbook['subject'] = subjects[i];
      break;
    }
  }

  for (int i = 0; i < tags.length; i++) {
    if (newbook['title'].contains(tags[i])) {
      print('tag:${tags[i]}');
      try {
        newbook['tags'].add(tags[i]);
      } on LCException catch (e) {
        print('错误：${e.code}:${e.message}');
      }
    }
  }

  await newbook.save();
}
