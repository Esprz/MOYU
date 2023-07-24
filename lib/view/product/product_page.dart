import 'package:MOYU/config/decoration.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/view/product/seller_item.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var book = context.watch<ProductModel>().bookinfo;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('商品详情'),
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
          body: Scrollbar(
            showTrackOnHover: true,
            thickness: MediaQuery.of(context).size.width * 0.025,
            radius: Radius.circular(20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.all(3),
                        alignment: Alignment.center,
                        child: Text(
                          '提示：注意关注教辅的出版时间和适用教材的版本哦!',
                          style: TextStyle(color: Colors.black38),
                        )),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: DefaultDecoration.gooditemDec,
                        child: _goodImage(book['img'].toString(), context)),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      height: DefaultDecoration.spacing,
                    ),
                  ),
                  //图书信息
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      //margin外 padding内
                      padding: EdgeInsets.all(20),
                      //padding: EdgeInsetsDefault.BookInfoBoxInset,
                      decoration: DefaultDecoration.gooditemDec,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _goodTitle(book['title'].toString()),
                          _goodPrice(book['price']),
                          _goodISBN(book['ISBN'].toString()),
                          _goodInfo(context)
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Container(height: DefaultDecoration.spacing)),

                  //卖家信息
                  SliverToBoxAdapter(child: _sellers(context)),
                  /**/
                ],
              ),
            ),
          )),
    );
  }

  Widget _sellers(BuildContext context) {
    var sellers = context.watch<ProductModel>().sellerList;
    return Container(
      decoration: DefaultDecoration.gooditemDec,
      //padding: EdgeInsetsDefault.BookInfoBoxInset,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: sellers.length,
        itemBuilder: (context, index) {
          return SellerItem(sellers[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: DefaultColor.DividerCol,
          );
        },
      ),
    );
  }

  Widget _goodTitle(title) {
    return Container(
      //margin: EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        overflow: TextOverflow.visible,
        style: TextStyleDefault.DetailedBook_Title,
      ),
    );
  }

  Widget _goodImage(urll, BuildContext context) {
    return Container(
        padding: EdgeInsetsDefault.BookImageInset,
        width: MediaQuery.of(context).size.width * 0.5,
        child: FadeInImage.assetNetwork(
          placeholder: 'images/clip-loading.gif',
          image: urll)//Image.network(urll)
        );
  }

  Widget _goodPrice(price) {
    return Container(
      //padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      child: Text(
        '${price} 元',
        style: TextStyleDefault.DetailedBook_Price,
      ),
    );
  }

  Widget _goodISBN(isbn) {
    return Container(
      //padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 10.0),
      child: Text(
        'ISBN: $isbn',
        style: TextStyle(fontSize: 15, color: Colors.black54),
      ),
    );
  }

  Widget _goodInfo(BuildContext context) {
    var book = context.watch<ProductModel>().bookinfo;
    return Container(
      //padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top: 8.0),
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            //出版时间
            if (book['pubdate'] != null && book['pubdate'] != '')
              Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Chip(label: Text('${book['pubdate'].toString()}出版'))),
            //版本
            if (book['version'] != null && book['version'] != '')
              Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Chip(label: Text('${book['version'].toString()}'))),
            //学科
            if (book['subject'] != null && book['subject'] != '')
              Container(
                  padding: EdgeInsets.only(right: 5),
                  child: Chip(label: Text(book['subject'].toString()))),
          ])),
          //标签
          if (book['tags'] != null)
            SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
              return Container(
                padding: EdgeInsets.only(right: 5),
                child: Chip(label: Text(book['tags'][i].toString())),
              );
            }, childCount: book['tags'].length)),
        ],
      ),
    );
  }
}
