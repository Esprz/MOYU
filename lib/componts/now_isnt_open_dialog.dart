import 'package:flutter/material.dart';

Future NotOpen(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text('该功能暂未开通'),
          ));
  
}
