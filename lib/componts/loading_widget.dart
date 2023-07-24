import 'package:MOYU/utils/router_util.dart';
import 'package:flutter/material.dart';

Widget LoadingWidget(BuildContext context) {
  return Container(
    //height: MediaQuery.of(context).size.height,
    //width: MediaQuery.of(context).size.width,
    child: Center(
      child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: Colors.black,
          )),
    ),
  );
}

loadingAction(BuildContext context) async {
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
}
