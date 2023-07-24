import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'dart:io';
import 'package:dio/dio.dart';

UpdateDialog(BuildContext context) {
  showDialog(
      barrierDismissible: false, //不让点周围返回
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async => false, //不让返回键返回
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              content: Opacity(
                opacity: 0.8,
                child: Container(
                    width: 100,
                    height: 250,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MOYU有新版本啦',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '快快更新吧ヾ(≧▽≦*)o',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          height: 15,
                        ),
                        Image.asset('images/gummy-app-development.png'),
                        Container(
                          height: 15,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) =>
                                            Color.fromARGB(200, 47, 169, 237))),
                            child: Container(
                                width: 70,
                                child: Text(
                                  '更 新',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                )),
                            onPressed: () async {
                              //var url ='https://www.pgyer.com/apiv2/app/install';
                              var url =
                                  'https://www.pgyer.com/apiv2/app/install?_api_key=5f65180e2a8c84b90804abfc34822435&appKey=22070a32b6530a997fde1bf446ece62a';
                              RUpgrade.upgradeFromUrl(url);

                              /*
      
                              File _apk = await downloadUpgrade(url, context);
      
                              var _apkPath = _apk.path;
                              //print(_apkPath);
      
                              if (_apkPath.isEmpty) {
                                //print('下载失败');
                              } else {
                                //print('下载成功');
      
                                try {
                                  AppInstaller.installApk(_apkPath);
                                  //openFile.open(_apk.path);
                                  //print('安装成功');
      
                                } on Exception catch (e) {
                                  // TODO
                                }
                              }*/

                              //RouterUtil.pop(context);
                            }),
                      ],
                    )),
              ),
            ),
          ));
}

downloadUpgrade(String url, BuildContext context) async {
  String fileName = 'MOYU';

  Directory? storageDir = await getExternalStorageDirectory();
  String storagePath = storageDir!.path;
  String filePath = '${storagePath}/${fileName}';
  File file = new File(filePath);
  //print('4');
  //print('filePath:${filePath}');

  try {
    //print('5');
    Dio dio = new Dio();
    Response res = await dio.download(
      url,
      filePath,
      queryParameters: {
        '_api_key': '5f65180e2a8c84b90804abfc34822435',
        'appKey': '22070a32b6530a997fde1bf446ece62a'
      },
      onReceiveProgress: (count, total) {
        try {
          showDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                    content: Container(
                      height: 250,
                      child: Column(children: [
                        //LinearProgressIndicator(),
                        Image.asset('images/clip-loading.gif'),
                        Container(
                          height: 15,
                        ),
                        AutoSizeText('小破APP下载中……请耐心等待'),
                      ]),
                    ),
                  ));
        } catch (exception) {
          //print(exception.toString());
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('错误:${exception.toString()}')));
        }

        /*
        var d = (count / total).toStringAsFixed(2);
        var _dPercent = double.parse(d)*100;
        
        showDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
                  content: Column(
                    children: [
                      LinearProgressIndicator(value: _dPercent),
                      Container(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Text('下载中……'), Text('${_dPercent}%')],
                      )
                    ],
                  ),
                ));
        //print('现在进度：当前 ${count} 总 ${total}');
        //setState(() {});
        */
      },
    );

    if (res.statusCode == 200) {
      //print('7');
    }
    return file;
  } catch (exception) {
    //print('6');
    //print(exception.toString());
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('错误:${exception.toString()}')));
  }
}
