import 'dart:convert';

import 'package:http/http.dart' as http;

String version = '';
bool ifneedupdate = false;
var tmp;

CheckUpdate() async {
  try {
    //print('3333333333CheckUpdate');
    var res = await http
        .post(Uri.parse('https://www.pgyer.com/apiv2/app/check'), body: {
      '_api_key': "5f65180e2a8c84b90804abfc34822435",
      'appKey': '22070a32b6530a997fde1bf446ece62a',
    });
    //print('res.body: ${res.body}');
    //print('res.code:${res.statusCode}');
    //print('3333333333');
    //print('lalalalaala');
    tmp = jsonDecode(res.body);
    ifneedupdate = tmp['data']['buildHaveNewVersion'];
    //print(ifneedupdate);
    //print(tmp['data']['downloadURL']);
    //print('3333333333：${ifneedupdate}');

    if (ifneedupdate == false) {
      return false;
    } else {
      return tmp['data']['downloadURL'];
    }
  } on Exception catch (e) {
    //print(e.toString());
    //print('22222222222');
    // TODO
  }
}

/*
res.body: {
  "code":0,
  "message":"",
  "data":{"buildBuildVersion":"1",
"forceUpdateVersion":"1.0.0",
"forceUpdateVersionNo":"1",
"needForceUpdate":false,
"downloadURL":"https:\/\/www.pgyer.com\/app\/installUpdate\/8a0b253559ee46cd4a576b46fd3c2762?sig=xz%2Bb26zI6Yv9cNqCsWeaHVU2%2FJ7d%2BELIG9ObnsHhvUtXwaTG%2Bhnod4kUOV03V9sA&forceHttps=",
"buildHaveNewVersion":false,
"buildVersionNo":"1",
"buildVersion":"1.0.0",
"buildUpdateDescription":"",
"appKey":"22070a32b6530a997fde1bf446ece62a",
"buildKey":"8a0b253559ee46cd4a576b46fd3c2762",
"buildName":"MOYU",
"buildIcon":"https:\/\/cdn-app-icon.pgyer.com\/d\/5\/8\/a\/c\/d58ac1c6931031551eb2cf647672acdd?x-oss-process=image\/resize,m_lfit,h_120,w_120\/format,jpg",
"buildFileKey":"5bb04f46c4d01bf129c532b11d95ee14.apk",
"buildFileSize":"29700155"}}*/