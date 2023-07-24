import 'package:MOYU/data/change_onsell_data_center.dart';
import 'package:MOYU/view/user/on_sell_list/change_product_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnSellItemPage extends StatelessWidget {
  const OnSellItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var item = context.watch<ChangeOnSellDataCenter>().changeonsellgood;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        margin: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(child: ChangeProductAction(item)),
      )),
    );
  }
}
