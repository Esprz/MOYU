import 'dart:async';

import 'package:flutter/material.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/data/search_result_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:provider/provider.dart';

enum LoadingStatus { LOADING, COMPLETED, IDEL }
String LoadText = '加载中';
ScrollController _scrollController = ScrollController();
Timer? _timer;

class SearchResultPage extends StatefulWidget {
  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String bookname = '';
  bool selectListview = true;
  TextEditingController newbookname = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectListview = false;
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        if (_timer != null) _timer!.cancel();
        _timer = Timer(Duration(milliseconds: 100), (() async {
          await _loadMoreData(context);
        }));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    //_scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
              style: TextStyle(color: Colors.black87),
              controller: newbookname,
              decoration: InputDecoration(
                  hintText: "搜索", hintStyle: TextStyle(color: Colors.black38))),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await Provider.of<SearchResultDataCenter>(context,
                          listen: false)
                      .initSearchData(newbookname.text, [], '',[], context);
                  RouterUtil.toSearchResultPage(context);
                },
                icon: const Icon(Icons.search))
          ],
        ),
        /*
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(
            Icons.shopping_cart,
          ),
          onPressed: () async {
            await Provider.of<CartDataCenter>(context, listen: false)
                .initData();
            RouterUtil.toCartPage(context);
          },
        ),
        */
        body: SafeArea(
          //maintainBottomViewPadding: ,

          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('大图浏览'),
                    Switch(
                      focusColor: Colors.black,
                      activeColor: Colors.black,
                      value: selectListview,
                      onChanged: (bool value) {
                        setState(() {
                          selectListview = value;
                        });
                      },
                    ),
                  ],
                ),
                selectListview == true
                    ? _ImageShow(context)
                    : _ListShow(context)
              ]),
            ),
          ),
        ));
  }

  _loadMoreData(BuildContext context) async {
    //print('_load11111111111');
    var tmp = context.read<SearchResultDataCenter>();
    if (tmp.total > tmp.getsearchResultCount)
      await Provider.of<SearchResultDataCenter>(context, listen: false)
          .refreshSearchData(context);
    //print('加载完成');
  }

  Widget _ListShow(BuildContext context) {
    var resultlist = context.watch<SearchResultDataCenter>();

    openDetail(BuildContext context, int index) async {
      await Provider.of<ProductModel>(context, listen: false).initData(
          resultlist.searchResultList[index]['ISBN'].toString(), context);
      RouterUtil.toProductPage(context);
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: resultlist.getsearchResultCount,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(3),
            margin: EdgeInsets.all(10),
            decoration: DefaultDecoration.gooditemDec,
            child: InkWell(
              onTap: () => openDetail(context, index),
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(2, 2, 12, 2),
                        width: MediaQuery.of(context).size.width * 0.3,
                        //child: Image.network(),
                        child: FadeInImage.assetNetwork(                          
                            placeholder: 'images/clip-loading.gif',
                            image: resultlist.searchResultList[index]['img'].toString()),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              resultlist.searchResultList[index]['title']
                                  .toString(),
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            /*
                            Container(
                              height: 5,
                            ),
                            Text(
                              '${resultlist.searchResultList[index]['price']} 元',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16),
                            ),
                            */
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }

  Widget _ImageShow(BuildContext context) {
    var resultlist = context.watch<SearchResultDataCenter>();

    openDetail(BuildContext context, int index) async {
      //showDialog(context: context, builder: (BuildContext context)=>Future());
      Future(() => CircularProgressIndicator())
          .then((value) => Provider.of<ProductModel>(context, listen: false)
              .initData(resultlist.searchResultList[index]['ISBN'].toString(),
                  context))
          .whenComplete(
            () => RouterUtil.toProductPage(context),
          );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: GridView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: resultlist.getsearchResultCount,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(5),
            decoration: DefaultDecoration.gooditemDec,
            child: InkWell(
              onTap: () {
                openDetail(context, index);
              },
              child: Container(
                margin: EdgeInsets.all(5.0),
                padding: EdgeInsets.all(5.0),
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.centerLeft,
                child: Column(
                  children: [
                    FadeInImage.assetNetwork(placeholder: 'images/clip-loading.gif', image: resultlist.searchResultList[index]['img'].toString()),
                    //Image.network(),
                    Container(
                      height: 5,
                    ),
                    Text(
                      resultlist.searchResultList[index]['title'].toString(),
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*
                    Container(
                      height: 5,
                    ),
                    
                    Text(
                      '${resultlist.searchResultList[index]['price']} 元',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15),
                    )*/
                  ],
                ),
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.8),
      ),
    );
  }
}
