import 'package:MOYU/check_app_version.dart';
import 'package:MOYU/componts/update_dialog.dart';
import 'package:MOYU/data/like_data_center.dart';
import 'package:MOYU/view/user/like_good_list/user_like_list_page.dart';
import 'package:flutter/material.dart';
import 'package:MOYU/model/home_page_featured_model.dart';
import 'package:MOYU/view/homepage.dart';
import 'package:MOYU/view/user/user_profile.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);
  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();
    _upgrade();
  }

  _upgrade() async {
    var tmp = await CheckUpdate();
    if (tmp != false) {
      Future.delayed(Duration(milliseconds: 30), (() {
        UpdateDialog(context);
      }));
    }
  }

  int _selectIndex = 0;
  Widget _currBody = HomePage();

  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
    //BottomNavigationBarItem(icon: Icon(Icons.comment), label: "消息"),
    //BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "购物车"),
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "收藏"),
    BottomNavigationBarItem(icon: Icon(Icons.perm_identity), label: "我的")
  ];

  //List<Widget> tabBodies = [HomePage(), MessagePage(), UserProfilePage()];

  onTapped(int index) async {
    switch (index) {
      case 0:
        Provider.of<HomePageFeaturedModel>(context, listen: false).initData();
        /*
        await showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 2), (() {
                RouterUtil.pop(context);
              }));
              return Container(
                  height: 50,
                  width: 50,
                  child: Center(child: LoadingWidget(context)));
            });
            */
        _currBody = HomePage();
//        UserInitializationPage()

        break;

      case 1:
        //_currBody = CommunicatePage();
        //_currBody =loading();
        //break;

        //case 2:
        //Provider.of<CartDataCenter>(context, listen: false).initData();
        /*
        await showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 2), (() {
                RouterUtil.pop(context);
              }));
              return Container(
                  height: 50,
                  width: 50,
                  child: Center(child: LoadingWidget(context)));
            });
            */
        //_currBody = CartPage();
        Provider.of<LikeDataCenter>(context, listen: false).initData(context);
        _currBody = UserLikePage();

        break;

      case 2:
        _currBody = UserProfilePage();

        break;
      //case 3:
      //_currBody =
    }
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currBody,
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Color.fromARGB(67, 92, 92, 92),
        items: bottomTabs,
        type: BottomNavigationBarType.shifting,

        //selectedFontSize: 14,
        //unselectedFontSize: 14,
        onTap: (index) {
          onTapped(index);
        },
        currentIndex: _selectIndex,
      ),

      /*
          body: IndexedStack(
            index: _selectIndex,
            children: tabBodies,
          ),
          */
    );
  }
}
