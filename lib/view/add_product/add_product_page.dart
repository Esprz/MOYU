import 'package:MOYU/config/decoration.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MOYU/data/add_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/view/add_product/add_product_action.dart';
import 'package:MOYU/view/add_product/search_isbn.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  int _ifscan = 0;
  bool _ifcanadd = false;

  String barcode = '';

  @override
  void initState() {
    super.initState();
  }

  Widget Goodlist() {
    var addlist = context.watch<AddDataCenter>();

    return Container(
        child: Scrollbar(
      showTrackOnHover: true,
      thickness: MediaQuery.of(context).size.width * 0.025,
      radius: Radius.circular(20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(3),
                  child: AutoSizeText(
                    '由于接口藏书不全，存在部分图书无法识别现象',
                    style: TextStyle(color: Colors.black54),
                  ))),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
                /*
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(width: 2),
                ),*/
                decoration: DefaultDecoration.gooditemDec,
                child: AddProductAction(addlist.addgoodList[index], index),
              );
            },
            childCount: addlist.addgoodList.length,
          )),
        ],
      ),
    ));
  }

  onPress() async {
    await _scan();
    //print('2barcode: $barcode');

    if (_ifscan == 0 && barcode != '') {
      //print(barcode);
      //print('进来了1');

      LCQuery<LCObject> query = LCQuery('product');
      query.whereEqualTo('ISBN', barcode);
      var tmp;

      try {
        tmp = await query.first();
      } on LCException catch (exception) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('错误:${exception.code}:${exception.message}')));
      }

      //print('进来了2');

      //内库存未查到
      if (tmp == null || tmp['ISBN'] != barcode) {
        //print('自己的库存没有');

        //调用接口
        bool ifSearchSuccess = await SearchISBN(barcode, context);
        if (ifSearchSuccess) _ifcanadd = true;
        //接口返回正确的：
        //接口返回也没有的
      }
      //Leancloud内库存有
      else {
        //print('自己的库存有');
        _ifcanadd = true;
      }

      //print('进来了3');

      if (_ifcanadd) {
        await Provider.of<AddDataCenter>(context, listen: false)
            .addgood(barcode, context);
        setState(() => _ifscan = 1);
      } else {
        setState(() => _ifscan = 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.add,
          ),
          onPressed: () async {
            await onPress();

            switch (_ifscan) {
              case 0: //未扫描
                //print('未扫描');
                break;

              case 1: //扫描成功
                //print('添加成功');
                break;

              case 2: //未查询到该isbn
                showDialog(
                    context: context,
                    builder: (BuildContext) => AlertDialog(
                          title: Text('添加失败'),
                          content: Text('很抱歉，未查询到该教辅，暂不支持上架此书。'),
                          actions: [
                            TextButton(
                                onPressed: () => RouterUtil.pop(context),
                                child: Text('返回'))
                          ],
                        ));
                break;
            }
          },
        ),
        appBar: AppBar(
          title: Text('加入商品页'),
        ),
        body: Goodlist());
  }

/*
  @override
  Widget Scanner(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: MobileScanner(
          allowDuplicates: false,
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('Barcode found! $code');
            }
          }),
    );
  }
  */

  _scan() async {
    try {
      // 此处为扫码结果，barcode为二维码的内容
      ScanResult result = await BarcodeScanner.scan();
      setState(() {
        barcode = result.rawContent;
        _ifscan = 0;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('barcode: $barcode')));
      //print('1barcode: $barcode');

    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        // 未授予APP相机权限
        setState(() {
          _ifscan = 3;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('未授予APP相机权限')));
      } else {
        // 扫码错误
        setState(() {
          //barcode = 'unknown error: $e';
          _ifscan = 4;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('错误:${e.code}:${e.message}')));
      }
    } on FormatException {
      // 进入扫码页面后未扫码就返回
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('进入扫码页面后未扫码就返回')));
      setState(() {
        //barcode ='null (User returned using the "back"-button before scanning anything. Result)';
        _ifscan = 0;
      });
    } catch (e) {
      // 扫码错误
      setState(() {
        //barcode = 'unknown error: $e';
        _ifscan = 4;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('错误:${e.toString()}')));
    }
  }
}
