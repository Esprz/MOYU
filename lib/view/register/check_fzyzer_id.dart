import 'package:dio/dio.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
CheckFzyzerID(String account, String pw,BuildContext context) async {
  //String account=_account

  var options = BaseOptions(
    baseUrl: 'http://old.fzyz.net/sys/login.shtml',
    //connectTimeout: 5000,
    //receiveTimeout: 3000,
  );

  try {
    Dio dio = Dio(options);
    var response = await dio.request(
      'http://old.fzyz.net/sys/login.shtml',
      data: {
        "staffCode": account,
        "password": pw,
        "loginRole": 2,
      },
      options: Options(
          method: 'POST',
          headers: {
            "Accept":
                "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            //"Access-Control-Allow-Origin": "*",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "zh-CN,zh;q=0.9",
            "Cache-Control": "max-age=0",
            "Connection": "keep-alive",
            //"Content-Length":" 32",
            "Content-Type": "application/x-www-form-urlencoded",
            "Cookie": "cookfzyzstaffCode="
                "; cookfzyzpwd="
                "; cookfzyzloginRole="
                "; cookfzyztype="
                "; _gscu_1967128415=48644712ntw88n19; _gscbrs_1967128415=1; JSESSIONID=0A3B83B12855B191EB2CC71601FD25DB; _gscs_1967128415=t486512764hbmm313|pv:3",
            "Host": "old.fzyz.net",
            "Origin": "http://old.fzyz.net",
            "Referer": "http://old.fzyz.net/index.jsp",
            "Upgrade-Insecure-Requests": "1",
            "User-Agent":
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.84 Safari/537.36",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          }),
    );
    //print('222222222222222222');

    //print(response.statusCode);
    //print(response.data);
    //print(response.statusMessage);

    if (response.statusCode == 302) {
      try {
        String url;
        //print(333333333);

        Map<String, String> tmp = Map();

        response.headers.forEach((name, values) {
          if (name == 'content-type') name = 'Content-Type';
          if (name == 'set-cookie') name = 'Cookie';
          if (tmp[name] == null) tmp[name] = '';
          for (int i = 0; i < values.length; i++)
            tmp[name] = tmp[name]! + values[i];
        });
        tmp.addAll({
          "Accept-Encoding": "gzip, deflate",
          "Accept-Language": "zh-CN,zh;q=0.9",
        });

        //print(tmp);
        //print('555555555');
        url = response.headers['location']![0];
        //print(url);
        tmp.remove('location');
        //print(333333333);
        //tmp.forEach((name, values) => print(name +": "+ values));
        //
        var res = await http.get(Uri.parse(url), headers: tmp);
        var webinfo = gbk.decode(res.bodyBytes);
        if (webinfo.contains('福州一中欢迎您! 学生个人主页')) {
          var r = webinfo.indexOf(' 同学,请选择');
          var l = webinfo.indexOf('欢迎您, ') + 5;
          String name = '';
          for (int i = l; i < r; i++) {
            name += webinfo[i];
          }
          //print(name);
          return name;
        } else {
          return 3;
        }
      } catch (exception) {
        //print(exception.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('错误：获取姓名失败：${exception.toString()}')));
        return 3;
      }
      //return 1;
    } else if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误：校网登陆失败:您未通过校网验证')));
      return 3;
    }
  } catch (e) {
    //print(e.toString());
    //验证身份错误
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('错误：${e.toString()}')));

    return 2;
  }
  throw '';
}

/*
void main() {
  //var url = 'http://old.fzyz.net/sys/login.shtml';
  diogetschool();
}
*/

//FLUTTER_STORAGE_BASE_URL
//,https://mirrors.tuna.tsinghua.edu.cn/flutter

//PUB_HOSTED_URL
//,https://mirrors.tuna.tsinghua.edu.cn/dart-pub
//https://pub.flutter-io.cn/

//31901010195
