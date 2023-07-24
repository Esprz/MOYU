import 'package:flutter/material.dart';
import 'package:MOYU/componts/loading_widget.dart';
import 'package:MOYU/config/decoration.dart';
import 'package:MOYU/model/product_model.dart';
import 'package:MOYU/data/add_data_center.dart';
import 'package:MOYU/data/search_result_data_center.dart';
import 'package:MOYU/utils/router_util.dart';
import 'package:MOYU/model/home_page_featured_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //HomePageState();
  late double Screenwidth, Screenheight;
  @override
  void initState() {
    super.initState();
  }

  _onPress(String t) async {
    switch (t) {
      case '教辅':
        Provider.of<SearchResultDataCenter>(context, listen: false)
            .initSearchData('', [], '教辅',[], context);
        RouterUtil.toSearchResultPage(context);

        break;
      case '工具书':
        await Provider.of<SearchResultDataCenter>(context, listen: false)
            .initSearchData('', ['工具书'], '', [],context);
        RouterUtil.toSearchResultPage(context);
        break;
      default:
        RouterUtil.toCategorizePage(context);
    }
  }

  TextEditingController bookname = TextEditingController();

  Widget BookComponent(String t, Color col) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.17,
      height: MediaQuery.of(context).size.width * 0.17,
      decoration: DefaultDecoration.homePageItemDec,
      child: InkWell(
          onTap: () {
            _onPress(t);
          },
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Icon(
                Icons.my_library_books,
                size: 40,
                color: col,
              )),
              Text(t),
            ],
          ))),
    );
  }

  Widget MoreComponent(String t) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.17,
      height: MediaQuery.of(context).size.width * 0.17,
      decoration: DefaultDecoration.homePageItemDec,
      child: InkWell(
          onTap: () {
            _onPress(t);
          },
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  child: Icon(
                Icons.format_list_bulleted,
                size: 40,
                color: Color.fromRGBO(251, 176, 59, 1),
              )),
              Text(
                t,
              ),
            ],
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    Screenwidth = MediaQuery.of(context).size.width;
    Screenheight = MediaQuery.of(context).size.height;
    double MaxGridWidth = (Screenwidth * 0.45).ceilToDouble();
    var featured = context.watch<HomePageFeaturedModel>();
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
              //style: TextStyle(
              //  color: Colors.white,
              //),
              controller: bookname,
              decoration: InputDecoration(
                //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                hintText: "搜索",
                //hintStyle: TextStyle(color: Colors.white)
              )),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await Provider.of<SearchResultDataCenter>(context,
                          listen: false)
                      .initSearchData(bookname.text, [], '',[], context);
                  RouterUtil.toSearchResultPage(context);
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: Scrollbar(
          trackVisibility: true,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: Column(
                  children: <Widget>[
                    //四个分类按钮
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //BookComponent('教材'),
                          BookComponent('教辅', Color.fromRGBO(161, 195, 252, 1)),
                          BookComponent(
                              '工具书', Color.fromRGBO(244, 166, 164, 1)),
                          MoreComponent('分类')
                        ],
                      ),
                    ),
                    //买或卖
                    Container(
                      //margin: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: DefaultDecoration.homePageItemDec,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: ClipOval(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Color.fromARGB(126, 237, 176, 176),
                                      child: Center(
                                        child: Text(
                                          '卖',
                                          style:
                                              TextStyleDefault.IndividualText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  right: 20,
                                  bottom: 20,
                                ),
                                InkWell(
                                    onTap: () async {
                                      await Provider.of<AddDataCenter>(context,
                                              listen: false)
                                          .initData(context);
                                      RouterUtil.toAddProductPage(context);
                                    },
                                    //child: Container(child: Image.asset("images/2.png"))
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      child: Image.asset(
                                          'images/clip-reading-books-1.png'),
                                      alignment: Alignment.center,
                                      /*
                                      child: Text(
                                        '卖',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),*/
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: MediaQuery.of(context).size.width * 0.4,
                            decoration: DefaultDecoration.homePageItemDec,
                            child: Stack(
                              children: [
                                Positioned(
                                  child: ClipOval(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      color: Color.fromARGB(126, 237, 176, 176),
                                      child: Center(
                                        child: Text(
                                          '买',
                                          style:
                                              TextStyleDefault.IndividualText,
                                        ),
                                      ),
                                    ),
                                  ),
                                  left: 20,
                                  bottom: 20,
                                ),
                                InkWell(
                                    onTap: () {
                                      RouterUtil.toCategorizePage(context);
                                    },
                                    //child: Container(child: Image.asset("images/2.png"))
                                    child: Container(
                                      /*
                                      child: Text(
                                        "买",
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      */
                                      margin: EdgeInsets.all(5),
                                      child: Image.asset(
                                          'images/clip-spending-time-at-home.png'),
                                      alignment: Alignment.center,
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    Divider(
                      color: DefaultColor.DividerCol,
                      thickness: 0.8,
                    )
                  ],
                ),
              )),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () async {
                              await Provider.of<ProductModel>(context,
                                      listen: false)
                                  .initData(featured.featured[index]['ISBN'],
                                      context);
                              RouterUtil.toProductPage(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: DefaultDecoration.gooditemDec,
                              width: MaxGridWidth,
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: FadeInImage.assetNetwork(
                                        placeholder: 'images/clip-loading.gif',
                                        image: featured.featured[index]['img']),
                                    /*Image.network(
                                    ,
                                    fit: BoxFit.fitWidth,
                                  )*/
                                  ),
                                  Text(
                                    featured.featured[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  //Text(featured.featured[index]['price'],maxLines: 1,overflow: TextOverflow.ellipsis,)
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: featured.featuredCount,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.8)),

                //推荐商品
              ),
            ],
          ),
        ),
      ),
    );
  }
}
