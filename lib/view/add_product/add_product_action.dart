// ignore: unused_import
import 'package:MOYU/utils/router_util.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/data/add_data_center.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:provider/provider.dart';

class AddProductAction extends StatelessWidget {
  AddProductAction(this.item, this.No);

  int No = 0;

  LCObject item = LCObject('good'), bookinfo = LCObject('product');

  late String imageurl = item['goodimage'];

  late String isbn = item['ISBN'], _userId = item['providerId'];

  bool ifOnSell = false;

  @override

  //List<No> _initValue = [];

  List<String> price = [
    '免费转手',
    '10%',
    '20%',
    '30%',
    '40%',
    '50%',
    '60%',
    '70%',
    '80%',
    '90%',
  ];
  List<String> newold = [
    '全新(未写)',
    '几乎全新(未写)',
    '九成新',
    '八成新',
    '七成新',
    '五成新',
    '大部分已书写'
  ];
  List<String> flaws = ['轻微磕碰褶皱', '明显磕碰褶皱', '答案缺失(但有电子版答案)', '已书写部分较潦草'];
  List<String> deliveryTime = ['三天内', '一周内', '一月内', '更久'];
  List<String> tags = [
    '高一',
    '高二',
    '高三',
    '工具书',
    '高中综合',
  ];
  List<String> version = ['新教材', '旧教材', '其他'];

  List<String> subject = [
    '语文',
    '数学',
    '英语',
    '物理',
    '化学',
    '生物',
    '历史',
    '地理',
    '政治',
    '其他',
  ];

  _onPressNewOld(String i, BuildContext context) async {
    item['newold'] = i;
    await Provider.of<AddDataCenter>(context, listen: false)
        .changeNewold(No, i);
  }

  _onPressVersion(String i, BuildContext context) async {
    item['version'] = i;
    await Provider.of<AddDataCenter>(context, listen: false)
        .changeVersion(No, i);
  }

  _onPressDeliveryTime(String i, BuildContext context) async {
    item['deliveryTime'] = i;
    await Provider.of<AddDataCenter>(context, listen: false)
        .changeDeliveryTime(No, i);
  }

  _onPressBad(String i, bool addordel, BuildContext context) async {
    await Provider.of<AddDataCenter>(context, listen: false)
        .changeflaw(No, i, addordel);
    /*
    if (addordel == true) {
      //item.addUnique('disadvantages', i);
    } else 
      //item.remove('disadvantages', i);
    }*/
  }

  _onPressPrice(String i, BuildContext context) async {
    //print('_onPressPrice');
    item['sellprice'] = i;
    //print('_onPressPrice111111111111');
    await Provider.of<AddDataCenter>(context, listen: false).changePrice(No, i);
    //print('_onPressPrice222222222222');
  }

  Widget _sellPrice(BuildContext context) {
    var _selectIndex =
        context.watch<AddDataCenter>().addgoodList[No]['sellprice'] ?? '';
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '售价 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            //width:600,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: price.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(price[index]),
                      selected: _selectIndex == price[index],
                      onSelected: (bool value) {
                        _selectIndex = price[index];
                        _onPressPrice(price[index], context);
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  Widget _sellNewold(BuildContext context) {
    var _selectIndex =
        context.watch<AddDataCenter>().addgoodList[No]['newold'] ?? '';
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '新旧 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newold.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(newold[index]),
                      selected: _selectIndex == newold[index],
                      onSelected: (bool value) {
                        _selectIndex = newold[index];
                        _onPressNewOld(newold[index], context);
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  Widget _goodflaw(BuildContext context) {
    var _filters =
        context.watch<AddDataCenter>().addgoodList[No]['flaws'] ?? [];
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '瑕疵 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: flaws.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(flaws[index]),
                      selected: _filters.contains(flaws[index]),
                      onSelected: (bool value) async {
                        if (value) {
                          _filters.add(flaws[index]);
                          await _onPressBad(flaws[index], true, context);
                        } else {
                          _filters.remove(flaws[index]);
                          await _onPressBad(flaws[index], false, context);
                        }
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  Widget _goodversion(BuildContext context) {
    var _selectIndex =
        context.watch<AddDataCenter>().addgoodList[No]['version'] ?? '';
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '版本 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: version.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(version[index]),
                      selected: _selectIndex == version[index],
                      onSelected: (bool value) {
                        _selectIndex = version[index];
                        _onPressVersion(version[index], context);
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  Widget _changeDirectBuy(BuildContext context) {
    bool ifDirectBuy =
        context.watch<AddDataCenter>().addgoodList[No]['ifDirectBuy'] ?? false;
    return Container(
        child: Switch(
            value: ifDirectBuy,
            onChanged: (bool v) async {
              if (ifDirectBuy == true) {
                await Provider.of<AddDataCenter>(context, listen: false)
                    .changeifDirectBuy(No, false);
              } else {
                await Provider.of<AddDataCenter>(context, listen: false)
                    .changeifDirectBuy(No, true);
              }
            }));
  }

  bool _canputaway = false;

  _ifCanPutAway(BuildContext context) {
    var item = context.read<AddDataCenter>().addgoodList[No];
    _canputaway = (item['newold'] != null &&
        item['version'] != null &&
        item['sellprice'] != null &&
        item['subject'] != null &&
        item['deliveryTime'] != null);
  }

  Widget _changeOnsellState(BuildContext context) {
    bool ifOnSell =
        context.watch<AddDataCenter>().addgoodList[No]['ifOnSell'] ?? false;
    return Container(
        child: Switch(
            value: ifOnSell,
            onChanged: (bool v) async {
              _ifCanPutAway(context);
              if (_canputaway == false) {
                showDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                          content: Text(
                            '信息未填写完整，无法上架',
                          ),
                        ));
              } else {
                if (ifOnSell == true) {
                  //ifOnSell = true;
                  await Provider.of<AddDataCenter>(context, listen: false)
                      .changeOnSellState(No, false);
                } else {
                  //ifOnSell = false;

                  await Provider.of<AddDataCenter>(context, listen: false)
                      .changeOnSellState(No, true);
                }
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    var good = context.watch<AddDataCenter>().addgoodList[No];

    var addlist = context.watch<AddDataCenter>();
    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 5,
              ),
              Row(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'images/clip-loading.gif',
                    image: imageurl,
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),
                  /* Image.network(
                    imageurl,
                    width: MediaQuery.of(context).size.width * 0.35,
                  ),*/
                  Container(width: 5,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          '${good['goodtitle']} ',
                          maxLines: 2,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Container(
                          height: 5,
                        ),
                        AutoSizeText(
                          '原价: ${good['goodprice']}  ',
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black54),
                        ),
                        Container(
                          height: 5,
                        ),
                        AutoSizeText(
                          '出版时间: ${good['goodpubdate']} ',
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black54),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => CupertinoAlertDialog(
                                          title: Text('信息有误'),
                                          actions: [
                                            _changebookinfochange(context),
                                            _changeBookPrice(context),
                                            _changeBookPubdate(context)
                                          ],
                                        ));
                              },
                              child: Text(
                                '信息有误?',
                                style: TextStyle(color: Colors.black54),
                              ),
                              style: ButtonStyle(
                                  textStyle: MaterialStateTextStyle.resolveWith(
                                      (states) => TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                  foregroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.black)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 5,
              ),
              /*
              Row(
                children: [
                  AutoSizeText('联系我后才可下单'),
                  _changeDirectBuy(context),
                  AutoSizeText('我社恐！直接下单'),
                ],
              ),*/
              Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 5,
                      ),
                      _goodversion(context),
                      _sellPrice(context),
                      _sellNewold(context),
                      _goodflaw(context),
                      _goodSubject(context),
                      _goodtags(context),
                      _sellDeliveryTime(context)
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('上架'),
                        _changeOnsellState(context),
                      ],
                    ),
                    Row(
                      children: [
                        Text('删除'),
                        IconButton(
                          onPressed: () async {
                            await Provider.of<AddDataCenter>(context,
                                    listen: false)
                                .delgood(item);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sellDeliveryTime(BuildContext context) {
    var _selectIndex =
        context.watch<AddDataCenter>().addgoodList[No]['deliveryTime'] ?? '';

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '发货时间 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: deliveryTime.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(deliveryTime[index]),
                      selected: _selectIndex == deliveryTime[index],
                      onSelected: (bool value) {
                        _selectIndex = deliveryTime[index];
                        _onPressDeliveryTime(deliveryTime[index], context);
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  Widget _goodtags(BuildContext context) {
    var _filters = context.watch<AddDataCenter>().addgoodList[No]['tags'] ?? [];
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '标签 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tags.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(tags[index]),
                      selected: _filters.contains(tags[index]),
                      onSelected: (bool value) async {
                        if (value) {
                          _filters.add(tags[index]);
                          await _onPressTag(tags[index], true, context);
                        } else {
                          _filters.remove(tags[index]);
                          await _onPressTag(tags[index], false, context);
                        }
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  _onPressTag(String i, bool addordel, BuildContext context) async {
    await Provider.of<AddDataCenter>(context, listen: false)
        .changetag(No, i, addordel);
    /*
    if (addordel == true) {
      //item.addUnique('disadvantages', i);
    } else 
      //item.remove('disadvantages', i);
    }*/
  }

  Widget _goodSubject(BuildContext context) {
    var _selectIndex =
        context.watch<AddDataCenter>().addgoodList[No]['subject'] ?? '';

    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.width,
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '学科 ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.67,
            height: 30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subject.length,
                itemBuilder: ((context, index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: FilterChip(
                      showCheckmark: true,
                      label: Text(subject[index]),
                      selected: _selectIndex == subject[index],
                      onSelected: (bool value) {
                        _selectIndex = subject[index];
                        _onPressSubject(subject[index], context);
                      },
                    ),
                  );
                })),
          )
          //SingleSelectionWidget(price, _onPressPrice),
        ],
      ),
    );
  }

  _onPressSubject(String i, BuildContext context) async {
    item['subject'] = i;
    await Provider.of<AddDataCenter>(context, listen: false)
        .changeSubject(No, i);
  }

  TextEditingController _infochange = TextEditingController();
  Widget _changebookinfochange(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: TextButton(
        child: Text(
          '书名有误',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext) => AlertDialog(
                    title: Text('修正书名'),
                    content: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: '输入书名', hintText: '修正后书名'),
                              controller: _infochange,
                            ),
                            Container(
                              height: 15,
                            ),
                            OutlinedButton(
                                onPressed: () async {
                                  await Provider.of<AddDataCenter>(context,
                                          listen: false)
                                      .changeBookTitle(No, _infochange.text);
                                },
                                child: Text('提交'))
                          ],
                        )),
                  ));
        },
      ),
    );
  }

  Widget _changeBookPrice(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: TextButton(
        child: Text(
          '原价有误',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext) => AlertDialog(
                    title: Text('修正原价'),
                    content: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: '输入价格', hintText: '修正后原价'),
                              controller: _infochange,
                            ),
                            Container(
                              height: 15,
                            ),
                            OutlinedButton(
                                onPressed: () async {
                                  await Provider.of<AddDataCenter>(context,
                                          listen: false)
                                      .changeBookPrice(No, _infochange.text);
                                },
                                child: Text('提交'))
                          ],
                        )),
                  ));
        },
      ),
    );
  }

  Widget _changeBookPubdate(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: TextButton(
        child: Text(
          '版本有误',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext) => AlertDialog(
                    title: Text('修正版本'),
                    content: Container(
                        height: MediaQuery.of(context).size.width * 0.5,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: '输入版本', hintText: '修正后版本'),
                              controller: _infochange,
                            ),
                            Container(
                              height: 15,
                            ),
                            OutlinedButton(
                                onPressed: () async {
                                  await Provider.of<AddDataCenter>(context,
                                          listen: false)
                                      .changeBookPubdate(No, _infochange.text);
                                },
                                child: Text('提交'))
                          ],
                        )),
                  ));
        },
      ),
    );
  }
}
