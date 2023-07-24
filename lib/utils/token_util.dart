import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

///token及登录信息处理工具
class TokenUtil extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;
  LCUser _localuser = LCUser();

  getuser() async {
    _localuser = await LCUser.getCurrent() ?? LCUser();
    notifyListeners();
  }

  LCUser get localuser {
    //print('localuser!!!!!!!1111');
    getuser();
    //print(_localuser);
    return _localuser;
  }

  String _nickname = '', _class = '', _grade = '';

  String get userclass => _class;
  String get usergrade => _grade;
  String get username => _nickname;

  ///判断是否登陆
  isLogin() async {
    String? token = "";

    ///读取本地存储数据
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //token = prefs.getString('token');

    _localuser = await LCUser.getCurrent() ?? LCUser();
    if (_localuser['nickname'] != null) {
      _nickname = _localuser['nickname'];
      _grade = _localuser['grade'];
      _class = _localuser['class'];
      return true;
    }
    else{
      return false;
    }

    //print('islogin!!!!!!!1111');
    //print(_localuser);

    ///如果查不到token则返回false
    //if (token == "" || token == null) {
      //print('查不到');
    //  return false;
    //}
    //return true;
    
  }

  getToken() async {
    //print('gettoken!!!!!!!1111');
    //print(_localuser);

    ///读取本地存储数据
    SharedPreferences prefs = await SharedPreferences.getInstance();

    ///获取token值
    String? token = await prefs.getString('token');
    return token;
  }

  saveLoginInfo(LCUser user) async {
    //user.toString();
    _localuser = await LCUser.getCurrent() ?? LCUser();

    _nickname = _localuser['nickname'];
    _grade = _localuser['grade'];
    _class = _localuser['class'];

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //var sessionToken=user.sessionToken.toString();
    await prefs.setString('token', user.sessionToken.toString());
    //await prefs.setString('updatedAt', user.updatedAt.toString());
    await prefs.setString('objectId', user.objectId.toString());
    await prefs.setString('nickname', user['nickname']);
    await prefs.setString('username', user.username.toString());
    //await prefs.setString('createdAt', user.createdAt.toString());
    //await prefs.setBool('emailVerified', user.emailVerified!);
    await prefs.setString('grade', user['grade']);
    await prefs.setString('class', user['class']);
    //await prefs.setBool('mobilePhoneVerified', user.emailVerified!);
    //print('savelogin!!!!!!!1111');
    //print(_localuser);

    notifyListeners();
  }

  //退出登录使用
  clearUserInfo(BuildContext context) async {
    try {
      await LCUser.logout();
      _localuser = await LCUser.getCurrent() ?? LCUser();
    } on LCException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误：${e.code}:${e.message}')));
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '');
    await prefs.setString('nickname', '');
    await prefs.setString('username', '');
    await prefs.setString('grade', '');
    await prefs.setString('class', '');
    await prefs.setString('objectId', '');

    notifyListeners();
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功退出')));
  }


  setUserPassword(String oldpw, String newpw, BuildContext context) async {
    _error = '';
    try {
      LCUser? currentUser = await LCUser.getCurrent();
      await currentUser!.updatePassword(oldpw, newpw);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('设置成功')));
      //return true;
    } on LCException catch (e) {
      // TODO
      //return false;
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
    }
  }

  String _error = '';
  String get error => _error;

  setUserClass(String newcls, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['class'] = newcls;
      //print(currentUser);
      await _localuser.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('class', newcls);
      _class = newcls;

      notifyListeners();
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;
    }
  }

  setUserGrade(String newgrd, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['grade'] = newgrd;
      //print(currentUser);
      await _localuser.save();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('grade', newgrd);
      _grade = newgrd;

      notifyListeners();
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;
    }
  }

  setUserContactWay(String _fstphone, String _fstqq, String _fstwechat,
      bool _ifcontactftf, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['wechat'] = _fstwechat;
      _localuser['qq'] = _fstqq;
      _localuser['phoneNum'] = _fstphone;
      _localuser['ifContactftf'] = _ifcontactftf;
      //print(currentUser);
      await _localuser.save();
      getuser();

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString('class', _fstclass);
      //_class = _fstclass;

      notifyListeners();
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;
    }
  }

  setUserPhoneNum(String _phone, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['phoneNum'] = _phone;
      //print(currentUser);
      await _localuser.save();
      getuser();

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString('class', _fstclass);
      //_class = _fstclass;

      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('设置成功')));
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;
    }
  }

  setUserQQ(String _qq, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['qq'] = _qq;
      //print(currentUser);
      await _localuser.save();
      getuser();

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString('class', _fstclass);
      //_class = _fstclass;

      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('设置成功')));
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;
    }
  }

  setUserWechat(String _wechat, BuildContext context) async {
    _error = '';
    try {
      //print('11111111111111');
      //print(_localuser);
      _localuser = await LCUser.getCurrent() ?? LCUser();
      _localuser['wechat'] = _wechat;
      //print(currentUser);
      await _localuser.save();
      getuser();

      //SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setString('class', _fstclass);
      //_class = _fstclass;

      notifyListeners();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('设置成功')));
      //return true;
    } on LCException catch (e) {
      _error = e.toString();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.code} : ${e.message}')));
      // TODO
      //return false;

    }
  }
}



  //获取用户信息
  /*
  static getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nickname = await prefs.getString('nickname');
    String? grade = await prefs.getString('grade');
    String? clas = await prefs.getString('class');
    String? objectId = await prefs.getString('objectId');
    //print('返回呀');
    return {
      'nickname': nickname,
      'grade': grade,
      'class': clas,
      'objectId': objectId,
    };
  }
*/